import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  
  final List<Pelicula> peliculas;

  // Callback that detects if the scroll continues
  final Function siguientePagina;

  MovieHorizontal({ @required this.peliculas,  @required this.siguientePagina});

  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3
  );

  @override
  Widget build(BuildContext context) {
    
    final _screenSize = MediaQuery.of(context).size;

    // Listen to the change in the Container
    _pageController.addListener((){
      if(_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200){
        siguientePagina();
      }
    });

    return Container(
      height: _screenSize.height * 0.2,
      // PageView Builder it's used for OnDemand Render Widgets
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        //children: _tarjetas(context),
        itemCount: peliculas.length,
        itemBuilder: (context, i) => _tarjeta(context, peliculas[i]),
      )
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula){
    // Add unique Id for Hero Animation between Horizontal Card and Detail Card
    pelicula.uniqueId = '${pelicula.id}-poster';
    final tarjeta = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          Hero(
            // Send uniqueId as Tag for Hero Animation
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPoster()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 100.0,
              ),
            ),
          ),
          SizedBox(height: 5.0,),
          Text(
            pelicula.title, 
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption
          )
        ],
      ),
    );
    return GestureDetector(
      child: tarjeta,
      onTap: (){
        print("Pelicula ${pelicula.title}");
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
    );
  }

  List<Widget> _tarjetas(BuildContext context){
    return peliculas.map((pelicula){
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPoster()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 100.0,
              ),
            ),
            SizedBox(height: 5.0,),
            Text(
              pelicula.title, 
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption
            )
          ],
        ),
      );
    }).toList();
  }
}