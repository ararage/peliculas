import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/utils/constants.dart';

class PeliculasProvider{
  
  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = new List();

  // Stream Controller for Popular movies in broadcast mode , 1 : N Consumers
  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  // Add Movies to the Stream Property
  Function(List<Pelicula>)get popularesSink => _popularesStreamController.sink.add;

  // Retrieve data from the Stream Property
  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  // Close Stream
  void disposeStreams(){
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> getData(String endpoint, { Map<String, String> extraParams }) async {
    Map<String, String> finalApiParams = apiParams;
    if(extraParams != null){
      finalApiParams= {}..addAll(apiParams)..addAll(extraParams);
    }
    final Uri url = Uri.https(apiMovies, endpoint, finalApiParams);
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final peliculas = Peliculas.fromJsonList(decodedData['results']);
    return peliculas.items;
  }

  Future<List<Pelicula>> getPopulares() async {
    // Retrieve Popular [Pelicula] objects from the themoviedb API endpoint '3/movie/popular' by page
    // Each page of data retrieved it's stored in the [List<Pelicula>._populares] List, for each call the [int._popularesPage] global var it's
    // incremented by one, after appending data to the List this one it's streamed to  [Function.popularesSink] property
    // from [StreamController<List<Pelicula>>._popularesStreamController] 
    if(_cargando) return [];
    _cargando = true;
    _popularesPage++;
    print("Cargando Siguientes....");
    final respuesta = await getData('3/movie/popular', extraParams: {'page':_popularesPage.toString()});
    _populares.addAll(respuesta);
    popularesSink(_populares);
    _cargando = false;
    return respuesta;
  }
}