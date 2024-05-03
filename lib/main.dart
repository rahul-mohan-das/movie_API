import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TVShowsPage extends StatefulWidget {
  @override
  _TVShowsPageState createState() => _TVShowsPageState();
}

class _TVShowsPageState extends State<TVShowsPage> {
  @override
  void initState() {
    super.initState();
    fetchShows();
  }

  List<dynamic> shows = [];
  Future<void> fetchShows() async {
    final response = await http.get(Uri.parse('https://api.tvmaze.com/shows'));
    if (response.statusCode == 200) {
      setState(() {
        shows = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load shows');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TV Shows'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(shows.length, (index) {
          return Card(
            child: Column(
              children: [
                Column(
                  children: [
                    Image.network(
                      shows[index]['image']['medium'] ??
                          'https://via.placeholder.com/150',
                      fit: BoxFit.cover,
                      height: 100,
                    ),
                    Text(
                      shows[index]['name'],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SecondRoute(showId: shows[index]['id']),
                      ),
                    );
                  },
                  child: Text("cast"),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class SecondRoute extends StatefulWidget {
  final int showId;

  SecondRoute({required this.showId});

  @override
  State<SecondRoute> createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  List<dynamic> castList = [];

  @override
  void initState() {
    super.initState();
    fetchShowCast();
  }

  Future<void> fetchShowCast() async {
    final response = await http
        .get(Uri.parse('https://api.tvmaze.com/shows/${widget.showId}/cast'));

    if (response.statusCode == 200) {
      setState(() {
        castList = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load cast');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cast'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: castList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(castList[index]['person']['name']),
              subtitle: Text(castList[index]['character']['name']),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TVShowsPage(),
  ));
}
