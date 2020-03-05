import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/utils/constants.dart';

class PeliculasProvider{
  
  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = new List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>)get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

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