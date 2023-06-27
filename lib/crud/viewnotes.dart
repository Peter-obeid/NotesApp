import 'package:flutter/material.dart';

class ViewNotes extends StatefulWidget {
  final notes;
  const ViewNotes({super.key, this.notes});

  @override
  State<ViewNotes> createState() => _ViewNotesState();
}

class _ViewNotesState extends State<ViewNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: Container(child: Column(children: [
           Container(child: Image.network("${widget.notes['imageurl']}",width: double.infinity,height: 300,fit: BoxFit.fill,), ),

           Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Text("${widget.notes['title']}", style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)),

            Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Text("${widget.notes['note']}", style: TextStyle(fontSize: 20,),))

      ],),),
    );
  }
}