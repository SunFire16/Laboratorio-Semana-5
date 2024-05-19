import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'types/post.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lanzamientos de SpaceX',
      theme: ThemeData(),
      home: PantallaConCards(),
    );
  }
}

class PantallaConCards extends StatefulWidget {
  @override
  _PantallaConCardsState createState() => _PantallaConCardsState();
}

class _PantallaConCardsState extends State<PantallaConCards> {
  late Future<List<Post>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts();
  }

  Future<List<Post>> fetchPosts() async {
    var url = Uri.https('api.spacexdata.com', 'v5/launches');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return postFromJson(response.body);
    } else {
      throw Exception('Error al cargar');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lanzamientos de SpaceX'),
      ),
      body: FutureBuilder<List<Post>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                var post = snapshot.data![index];
                return Card(
                  child: ListTile(
                    leading: post.links.patch.small != null
                        ? Image.network(post.links.patch.small!)
                        : Icon(Icons.image),
                    title: Text(post.name),
                    subtitle: Text(
                      'Fecha de lanzamiento: ${post.dateUtc.toLocal()} \nEstatus: ${post.success ? "Completado" : "Fallido"}',
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
