import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate{

  String seleccion = '';

  final peliculasProvider = new PeliculasProvider();

  final peliculas = [
    "WonderWoman", "1917", "Spiderman", "Capitan America"
  ];

  final peliculasRecientes = ["Spiderman", "Capitan America"];

  @override
  List<Widget> buildActions(BuildContext context) {
    // AppBar Actions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // AppBar Left Icon
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Results to show
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(
          seleccion
        ),
      )
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Suggestion results after Search as you type
    if(query.isEmpty){
      return Container();
    }
    return FutureBuilder(
      future: peliculasProvider.getData('3/search/movie', extraParams: {'query': query}),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if(snapshot.hasData){
          final peliculas = snapshot.data;
          return ListView(
            children: peliculas.map((pelicula){
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(pelicula.getPoster()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text( pelicula.title ),
                subtitle: Text( pelicula.originalTitle ),
                onTap: (){
                  close(context, null);
                  pelicula.uniqueId = '';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                },
              );
            }).toList()
          );
        }else{
          return Center(
            child: CircularProgressIndicator()
          );;
        }
      },
    );
  }

}