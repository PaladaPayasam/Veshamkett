import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final inputPath = 'stores_raw.json';
  final outputPath = 'stores_seed.csv';
  
  final file = File(inputPath);
  if (!await file.exists()) {
    print('Error: Could not find $inputPath');
    return;
  }
  
  final jsonString = await file.readAsString();
  final List<dynamic> stores = jsonDecode(jsonString);
  
  final outputFile = File(outputPath);
  final sink = outputFile.openWrite();
  
  // Write CSV Header matching Supabase schema (id is auto-gen)
  // schema: name, latitude, longitude, district, category
  sink.writeln('name,latitude,longitude,district,category');
  
  int successCount = 0;
  
  print('Starting Geocoding for ${stores.length} stores...');
  
  for (int i = 0; i < stores.length; i++) {
    final store = stores[i];
    final String name = store['name'];
    final String address = store['address'];
    final String district = store['district'];
    final String category = store['category'];
    
    print('Geocoding [${i + 1}/${stores.length}]: $name...');
    
    // We use Nominatim OpenStreetMap API
    // Must comply to 1 request per second
    await Future.delayed(const Duration(seconds: 1, milliseconds: 200));
    
    // URL encode address
    final query = Uri.encodeComponent(address);
    final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1');
    
    final request = await HttpClient().getUrl(url);
    request.headers.set('User-Agent', 'Veshamkett/1.0.0 (Data Scraper for Educational/Store mapping purposes)');
    final response = await request.close();
    
    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      final List<dynamic> result = jsonDecode(responseBody);
      
      if (result.isNotEmpty) {
        final double lat = double.parse(result[0]['lat']);
        final double lon = double.parse(result[0]['lon']);
        
        // Escape CSV quotes
        final safeName = name.contains(',') ? '"${name.replaceAll('"', '""')}"' : name;
        
        sink.writeln('$safeName,$lat,$lon,$district,$category');
        successCount++;
        print('  -> Success ($lat, $lon)');
      } else {
        // Fallback: search just by District if exact address fails (Very common for obscure Kerala street names)
        print('  -> Failed exact search, trying district fallback ($district, Kerala)...');
        await Future.delayed(const Duration(seconds: 1, milliseconds: 200));
        
        final fallbackQuery = Uri.encodeComponent('$district, Kerala, India');
        final fallbackUrl = Uri.parse('https://nominatim.openstreetmap.org/search?q=$fallbackQuery&format=json&limit=1');
        
        final fbReq = await HttpClient().getUrl(fallbackUrl);
        fbReq.headers.set('User-Agent', 'Veshamkett/1.0.0 (Data Scraper for Educational/Store mapping purposes)');
        final fbRes = await fbReq.close();
        
        final fbBody = await fbRes.transform(utf8.decoder).join();
        final List<dynamic> fbResult = jsonDecode(fbBody);
        
        if (fbResult.isNotEmpty) {
          final double lat = double.parse(fbResult[0]['lat']);
          final double lon = double.parse(fbResult[0]['lon']);
          final safeName = name.contains(',') ? '"${name.replaceAll('"', '""')}"' : name;
          sink.writeln('$safeName,$lat,$lon,$district,$category');
          successCount++;
          print('  -> Fallback Success ($lat, $lon)');
        } else {
          print('  -> Completely Failed to geocode.');
        }
      }
    } else {
      print('  -> API Error: \${response.statusCode}');
    }
  }
  
  await sink.close();
  print('Geocoding complete! Handled $successCount/${stores.length} successfully.');
  print('Results written to $outputPath');
}
