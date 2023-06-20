import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<dynamic> user = [];

  Future<void> _refresh() async {
    CargarPersonaje();
    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreenAccent[400],
        title: const TextField(
          decoration: InputDecoration(
            hintText: 'Buscar',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
            itemCount: user.length,
            itemBuilder: (context, index) {
              final users = user[index];
              final name = users['name'];
              final status = users['status'];
              final imageUrl = users['image'];
              return Card(
                elevation: 5,
                child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://media.tenor.com/BgR83Df82t0AAAAi/portal-rick-and-morty.gif'),
                          fit: BoxFit.cover)),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Text(
                        name.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25.0),
                      ),
                      Image.network(
                        imageUrl,
                        width: 200,
                        height: 200,
                      ),
                      Text(
                        status,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      FloatingActionButton(
                        backgroundColor: Colors.lightGreenAccent[400],
                        onPressed: () {
                          deletPersonaje();
                          user.remove(users);
                        },
                        child: const Icon(Icons.delete),
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreenAccent[400],
        onPressed: () {},
        child: const Icon(Icons.search),
      ),
    );
  }

  Future<void> CargarPersonaje() async {
    print('Buscando');
    const url = 'https://rickandmortyapi.com/api/character';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      user = json['results'];
    });
    print('Busqueda completada');
  }
}

Future<void> deletPersonaje() async {
  var url = Uri.parse('https://rickandmortyapi.com/api/character');
  var response = await http.delete(url);
  final body = response.body;
  final json = jsonDecode(body);

  if (response.statusCode == 404) {
    print('Personaje eliminado Correctamente');
  } else {
    print(
        'Error al eliminar el personaje. Código de estado: ${response.statusCode}');
  }
}
