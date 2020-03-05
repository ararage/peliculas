import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class PeliculaDetalle extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    // Get Arguments from Home Page, in this case the Selected Movie
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          // AppBar with background image and title
          _crearAppBar(pelicula),
          // Scroll Poster, Description, Rating, Title and original Title, Cast ...
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10.0,),
                _posterTitulo(context, pelicula),
                _descripcion(pelicula),
                _crearCast(pelicula)
              ]
            ),
          )
        ],
      )
    );
  }

  Widget _crearAppBar(Pelicula pelicula){
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0
          ),
        ),
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackroundImage()),
          placeholder: AssetImage('assets/img/loading.gif'),
          fadeInDuration: Duration(milliseconds: 15),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, Pelicula pelicula){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          // Receive uniqueId as Tag for Hero Animation
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage( pelicula.getPoster() ),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20.0,),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(pelicula.title, style: Theme.of(context).textTheme.title, overflow: TextOverflow.ellipsis,),
                Text(pelicula.originalTitle, style: Theme.of(context).textTheme.subhead, overflow: TextOverflow.ellipsis,),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text(pelicula.voteAverage.toString())
                  ],
                )
              ],
            ),
          )
        ],
      )
    );
  }

  Widget _descripcion(Pelicula pelicula){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _crearCast(Pelicula pelicula){
    final peliProvider = new PeliculasProvider();
    return FutureBuilder(
      future: peliProvider.getCast('3/movie/${pelicula.id}/credits'),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
         if (snapshot.hasData){
          return _creatActoresPageView(snapshot.data);
        }
        return Container(
          height: 300.0,
          child:Center(
            child: CircularProgressIndicator()
          )
        );
      },
    );
  }

  Widget _creatActoresPageView(List<Actor> actores){
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
        ),
        itemCount: actores.length,
        itemBuilder: (context, i) => _actorTarjeta(actores[i]),
      ),
    );
  }

  Widget _actorTarjeta(Actor actor){
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(actor.getPhoto()),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(actor.name, overflow: TextOverflow.ellipsis,)
        ],
      ),
    );
  }
}