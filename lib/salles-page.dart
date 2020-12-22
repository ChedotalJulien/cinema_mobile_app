import 'package:cinema_mobile_app/app-util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/painting.dart';

class SallesPage extends StatefulWidget {
  dynamic cinema;

  SallesPage(this.cinema);

  @override
  _SallesPageState createState() => _SallesPageState();
}

class _SallesPageState extends State<SallesPage> {
  List<dynamic> listSalles;
  List<int> selectedTickets = new List<int>();
  final nomClientController = TextEditingController();
  final codePaiementController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salle du Cinema ${widget.cinema['name']}'),
      ),
      body: Center(
        child: this.listSalles == null
            ? CircularProgressIndicator()
            : ListView.builder(
            itemCount:
            (this.listSalles == null) ? 0 : this.listSalles.length,
            itemBuilder: (context, index) {
              return Card(

                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: RaisedButton(
                            color: Colors.blueGrey,
                            child: Text(
                              this.listSalles[index]['name'],
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              loadProjections(this.listSalles[index]);
                            },
                          ),
                        ),
                      ),
                      if (this.listSalles[index]['projections'] != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Image.network(AppUtil.host +
                                  "/imageFilms/${this
                                      .listSalles[index]['currentProjection']['film']['id']}",
                                width: 160,
                              ),
                              Column(
                                children: <Widget>[
                                  ...this.listSalles[index]['projections'].map((projection) {
                                    return RaisedButton(

                                      color:(this.listSalles[index]['currentProjection']['id'] == projection['id'])
                                          ?Colors.green : Colors.blueGrey ,
                                      child:
                                      Text(
                                        "${projection['seance'] ['heureDebut']} "
                                            "Durée: ${projection['film']['duree']} - "
                                            "Tarif: ${projection['prix']} € ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12
                                        ),),
                                      onPressed: () {
                                        loadTickets(projection,this.listSalles[index]);
                                      },
                                    );
                                  })
                                ],
                              )
                            ],
                          ),
                        ),
                      if(this.listSalles[index]['currentProjection'] !=null &&
                          this.listSalles[index]['currentProjection']['listTickets'] !=null
                      )
                        Column(
                          children: <Widget>[

                            Row(
                              children: <Widget>[
                                Text("Il y a actuellement ${this.listSalles[index]['currentProjection']['nombrePlacesDisponibles']} places disponibles",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      height: 2
                                  ),)
                              ],
                            ),
                            if(selectedTickets.length>0)

                              Container(
                                padding: EdgeInsets.fromLTRB(6, 2, 6, 3),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Nom Du Client',
                                    hintStyle: TextStyle(color: Colors.black,fontSize: 20),


                                  ),
                                  controller: nomClientController,
                                ),
                              ),
                            if(selectedTickets.length>0)

                              Container(
                                padding: EdgeInsets.fromLTRB(6, 2, 6, 3),

                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Code du paiement' ,
                                    hintStyle: TextStyle(color: Colors.black,fontSize: 20),
                                  ),
                                  controller: codePaiementController,
                                ),
                              ),
                            if(selectedTickets.length>0)

                              Container(
                                width: double.infinity,
                                child: RaisedButton(
                                    color: Colors.white,
                                    child: Text("reserver les places" ,style:
                                    TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 24
                                    ),),

                                    onPressed:  (){
                                      setState(() {
                                        payerTickets(nomClientController.text,codePaiementController.text,
                                            selectedTickets,index);
                                      });
                                    }
                                ),
                              ),//
                            Wrap(
                              children: <Widget>[
                                ...this.listSalles[index]['currentProjection']['listTickets'].map((ticket){
                                  if(ticket['reserve'] == false)
                                    return Container(
                                      decoration: BoxDecoration(

                                        image: const DecorationImage(
                                          image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqs5ulBp3SayTovAtn9WnTEb5r5w3JSnG2nA&usqp=CAU'),
                                          fit: BoxFit.cover,
                                        ),
                                        border: Border.all(
                                          color: Colors.transparent,
                                          width: 8,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),


                                      padding: EdgeInsets.all(1.0),
                                      child: RaisedButton(

                                        color: (ticket['selected']!=null && ticket['selected']==true)?Colors.red:Colors.transparent,
                                        child: Text(
                                          "${ticket['place']['numero']}",

                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,



                                          ),),
                                        onPressed: () {
                                          setState(() {
                                            if(ticket["selected"]!=null && ticket["selected"]==true){
                                              ticket["selected"] = false;
                                              selectedTickets.remove(ticket['id']);
                                            }
                                            else{
                                              ticket['selected'] = true;
                                              selectedTickets.add(ticket['id']);
                                            }
                                          });
                                        },
                                      ),
                                    );
                                  else return Container();
                                })
                              ],
                            ),
                          ],
                        ),

                    ],
                  ));
            }),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.deepOrange,
          onPressed: (){

          }
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSalles();
  }
  @override
  void dispose(){
    nomClientController.dispose();
    codePaiementController.dispose();
    super.dispose();
  }

  void loadSalles() {
    String url = this.widget.cinema['_links']['salles']['href'];
    http.get(url).then((resp) {
      setState(() {
        this.listSalles = json.decode(resp.body)['_embedded']['salles'];
      });
    }).catchError((err) {
      print(err);
    });
  }

  void loadProjections(salle) {
    //String url1 = AppUtil.host + "/salles/${salle['id']}/projections?projection=p1";
    String url = salle['_links']['projections']['href']
        .toString()
        .replaceAll("{?projection}", "?projection=p1");
    http.get(url).then((resp) {
      setState(() {
        salle['projections'] =
        json.decode(resp.body)['_embedded']['projections'];
        salle['currentProjection'] = salle['projections'][0];
      });
    }).catchError((err) {
      print(url);
    });
  }


  void loadTickets(projection,salle) {
    String url = projection['_links']['tickets']['href']
        .toString()
        .replaceAll("{?projection}", "?projection=ticketProj");
    http.get(url).then((resp) {
      setState(() {
        projection['listTickets'] = json.decode(resp.body)['_embedded']['tickets'];
        salle['currentProjection']= projection;
        projection['nombrePlacesDisponibles'] = nombrePlacesDisponibles(projection);
      });
    }).catchError((err) {
      print(err);
    });
  }
  nombrePlacesDisponibles(projection){
    int nombre = 0 ;
    for(int i=0;i<projection['tickets'].length;i++){
      if(projection['tickets'][i]['reserve']==false)
        ++nombre;
    }
    return nombre;
  }

  void payerTickets(nomClient, codePayement,tickets, index) {
    Map data ={"nomClient":nomClient,"codePayement":codePayement,"tickets":tickets};
    String body = json.encode(data);
    http.post(AppUtil.host+"/payerTickets",headers: {"Content-type":"application/json"},body: body)
        .then((value) => loadTickets(this.listSalles[index]['currentProjections'],this.listSalles[index]))
        .catchError((err){
      print(err);
    });
    selectedTickets= new List<int>();
    loadProjections(this.listSalles[index]);
  }
}