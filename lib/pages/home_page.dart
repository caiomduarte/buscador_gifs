import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _search;

  int? _offset = 0;

  //Criano a função que faz a requisição
  Future<Map> _buscaGifs() async {
    http.Response response;

    var urlTrending = Uri.parse(
        "https://api.giphy.com/v1/gifs/trending?api_key=YC6shoTqMveiCPeUCTZLwG8BuIAa8RAl&limit=25&rating=g");

    var urlSearch = Uri.parse(
        "https://api.giphy.com/v1/gifs/search?api_key=YC6shoTqMveiCPeUCTZLwG8BuIAa8RAl&q=$_search&limit=25&offset=$_offset&rating=g&lang=en");

    if (_search == null) {
      response = await http.get(urlTrending);
    } else {
      response = await http.get(urlSearch);
    }

    return json.decode(response.body);
  }

  Widget _tabelaComGifs(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        //Determina a maneira que vamos organizar nossos items
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemCount: 4,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Image.network(
                snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                height: 300.0,
                fit: BoxFit.cover),
          );
        });
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    _buscaGifs().then((map) {
      print("dados");
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Image.network(
            "https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquisar gif",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _buscaGifs(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.done:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                            strokeWidth: 5.0 //largura,
                            ),
                      );
                    default:
                      if (snapshot.hasError) {
                        print("Deu erro");
                        return Container();
                      } else {
                        print("Deu certo");
                        return _tabelaComGifs(context, snapshot);
                      }
                  }
                }),
          )
        ],
      ),
    );
  }
}
