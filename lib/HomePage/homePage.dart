import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:untitled/crud/editNotes.dart';
import 'package:untitled/crud/viewnotes.dart';
import '../crud/viewnotes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


CollectionReference noteRef = FirebaseFirestore.instance.collection("notes");

getUser()async {
  var user = FirebaseAuth.instance.currentUser;

}

@override
  void initState() {
    getUser();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add),onPressed: () {Navigator.of(context).pushNamed("addnotes"); },),
      appBar: AppBar(
        title: const Text('HomePage'),
        actions: [
         IconButton(onPressed: ()async{
          await FirebaseAuth.instance.signOut();
          Navigator.of(context).pushNamed("login");
         }, icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(child: FutureBuilder(
        
        future: noteRef.where("userid", isEqualTo: FirebaseAuth.instance.currentUser?.uid).get(),
        builder: (context, snapshot){
          
          if(snapshot.hasData){
            return  ListView.builder(
        itemCount: snapshot.data!.docs.length ,
        itemBuilder: (context,i){
          return Container(
            
            height: 100,
            child: Dismissible(
              onDismissed: ((direction) async {
                await noteRef.doc(snapshot.data!.docs[i].id).delete();
                await FirebaseStorage.instance.refFromURL(snapshot.data!.docs[i]['imageurl']).delete();
              }),
              key: UniqueKey(), child: NotesClass(notes: snapshot.data!.docs[i], docid: snapshot.data!.docs[i].id,)),
          );
        });
          }
          return Center(child: CircularProgressIndicator(),);
          })),
    );
  }
}

class NotesClass extends StatelessWidget {
  final notes;
  final docid;
  NotesClass({this.notes, this.docid});
  

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() {
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return ViewNotes(notes:  notes,);
        }));
      }),
      child: Container(
        
        child: Card(
        child: Row(
          
          children: [
            Expanded(child: Image.network("${notes['imageurl']}"),flex: 1,),
            
            Expanded(
              flex: 2,
              child: ListTile(title: Text("${notes['title']}", style: TextStyle(fontWeight: FontWeight.bold),),
               subtitle: Text("${notes['note']}"),)
       
            ),
             Expanded(
              flex: 2,
               child: Container(
                      
                      child: IconButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return EditNotes(docid: docid, list: notes, );
                      }));}, icon: Icon(Icons.edit))),
             ),
                    
          ],
        ),
      ),),
    );
  }
}