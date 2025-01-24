import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic>? jsonData;

  Future<void> loadJsonAsset() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data.json');
      var data = jsonDecode(jsonString);
      setState(() {
        jsonData = data;
      });
    } catch (e) {
      setState(() {
        jsonData = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadJsonAsset();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard Viewer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => loadJsonAsset(),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
                child: Text(
                  'Dashboard Menu',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  // Add navigation logic here
                },
              ),
              ListTile(
                leading: const Icon(Icons.article),
                title: const Text('Articles'),
                onTap: () {
                  // Add navigation logic here
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  // Add navigation logic here
                },
              ),
            ],
          ),
        ),
        body: jsonData != null
            ? Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Overview',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: jsonData!['data'].length,
                  itemBuilder: (context, index) {
                    final article = jsonData!['data'][index];
                    final attributes = article['attributes'];
                    final relationships = article['relationships'];
                    final author = relationships['author']['data'];
                    final comments = relationships['comments']['data'];

                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              attributes['title'] ??
                                  'No Title Available',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Author: ${author['id']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(
                                  Icons.comment,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Comments: ${comments.length}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                const Icon(
                                  Icons.link,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    article['links']['self'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue,
                                      decoration:
                                      TextDecoration.underline,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )
            : const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
