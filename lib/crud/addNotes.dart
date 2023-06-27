
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:untitled/component/alert.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {

CollectionReference noteRef = FirebaseFirestore.instance.collection("notes");

  late Reference ref;
  var title, note, imageurl;

  final _formKey = GlobalKey<FormState>();

  late File file;

addNotes(context)async{
if(file == null){return AwesomeDialog(context: context, title: "Required", body: Text("Please choose an image"),dialogType: DialogType.infoReverse)..show();}
var formdata = _formKey.currentState;

if(formdata!.validate()){
  showLoading(context);
formdata.save();

await ref.putFile(file);
imageurl = await ref.getDownloadURL();


await noteRef.add({
"title" : title,
"note" : note,
"imageurl" : imageurl,
"userid" : FirebaseAuth.instance.currentUser!.uid,
});
Navigator.of(context).pushNamed("homepage");
}


}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add New Notes'),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                onSaved: (val) {
                  title = val;
                },
                validator: (val) {
                      if (val!.length > 30) {
                        return "Title cant be more than 30 letter";
                      }
                      if (val!.length < 2) {
                        return " Title cant be less than 1 letter";
                      }
                      return null;
                    },
                maxLength: 30,
                decoration: InputDecoration(
                    labelText: "Title", prefixIcon: Icon(Icons.note)),
              ),
              TextFormField(
                onSaved: (val) {
                  note = val;
                },
                validator: (val) {
                      if (val!.length > 1000) {
                        return "Note cant be more than 1000 letter";
                      }
                      if (val!.length < 1) {
                        return " Note cant be less than 2 letters";
                      }
                      return null;
                    },
                maxLength: 1000,
                decoration: InputDecoration(
                    labelText: "Your Note", prefixIcon: Icon(Icons.note)),
              ),
              ElevatedButton(
                  onPressed: () {
                    showButtomSheet(context);
                  },
                  child: Text("Add Your Image")),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    await addNotes(context);
                  },
                  child: Text("Save Note"),
                ),
              ),
            ],
          ),
        ));
  }

  showButtomSheet(context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              padding: EdgeInsets.all(20),
              height: 170,
              child: Column(
                children: [
                  Text(
                    "Please Choose Image",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    child: Row(
                      children: [
                        Container(
                            padding: EdgeInsets.only(left: 20),
                            child: InkWell(
                              onTap: (() async {
                              
                                final ImagePicker picked =  ImagePicker();
                                    final XFile? image = await  picked.pickImage(source: ImageSource.gallery);
                                    if(image != null){
                                      file = File(image.path);
                                      var rand = Random().nextInt(100000000000000);
                                      var imagename = "$rand" + basename(image.path);

                                       ref = FirebaseStorage.instance.ref("images").child("$imagename");
                                     Navigator.of(context).pop();


                                    }

                              }),
                              child: Icon(
                                Icons.photo_album_outlined,
                                size: 40,
                              ),
                            )),
                        Container(
                          padding: EdgeInsets.only(left: 150),
                          child: InkWell(
                            onTap: (() async {
                              
                               final ImagePicker picked =  ImagePicker();
                                    final XFile? image = await  picked.pickImage(source: ImageSource.camera);
                                       if(image != null){
                                      file = File(image.path);
                                      var rand = Random().nextInt(1000);
                                      var imagename = "$rand" + basename(image.path);

                                       ref = FirebaseStorage.instance.ref("images").child("$imagename");
                                       Navigator.of(context).pop();
                                     
   

                                    }
                            }),
                            
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 40,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 4, top: 3),
                        child: Text("From Gallery",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 100, top: 3),
                        child: Text("From Camera",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      )
                    ],
                  )
                ],
              ));
        });
  }
}
