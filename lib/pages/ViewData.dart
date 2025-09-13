import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/pages/HomePage.dart';

class ViewData extends StatefulWidget {
  ViewData({required Key key, this.document, required this.id})
      : super(key: key);

  final Map<String, dynamic>? document;

  final String id;

  @override
  State<ViewData> createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late String type;

  late String category;
  bool edit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String title =
        widget.document!['title'] == null || widget.document!['title'] == ""
            ? "Hey There"
            : widget.document!['title'];
    titleController = TextEditingController(text: widget.document!['title']);
    descriptionController =
        TextEditingController(text: widget.document!['description']);
    type = widget.document!['task'] == null || widget.document!['task'] == ""
        ? "important"
        : widget.document!['task'];
    category = widget.document!['category'] == null ||
            widget.document!['category'] == ""
        ? "Food"
        : widget.document!['category'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.blue, Colors.purple])),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        CupertinoIcons.arrow_left,
                        color: Colors.white,
                        size: 28,
                      )),
                  Row(
                    children: [
                      IconButton(onPressed: () {

                        FirebaseFirestore.instance.collection("Todo").doc(widget.id).delete().then((value) {
                          Navigator.pop(context);
                        });

                      }, icon: Icon(Icons.delete) , color: Colors.redAccent, iconSize: 28,),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              edit = !edit;
                            });
                          },
                          icon: Icon(
                            Icons.edit,
                            color: edit ? Colors.green : Colors.white,
                            size: 28,
                          )),
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      edit ? "Editting" : "View",
                      style: TextStyle(
                        fontSize: 33,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Your ToDo",
                      style: TextStyle(
                        fontSize: 33,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    label("Task Title"),
                    SizedBox(
                      height: 10,
                    ),
                    title(),
                    SizedBox(
                      height: 30,
                    ),
                    label("Task Type"),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        taskSelect("important", 0xFFE53935),
                        SizedBox(
                          width: 20,
                        ),
                        taskSelect("planned", 0xFF26C6DA),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    label("Task Description"),
                    SizedBox(
                      height: 10,
                    ),
                    description(),
                    SizedBox(
                      height: 30,
                    ),
                    label("Category"),
                    SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      runSpacing: 10,
                      children: [
                        categorySelect("Food", 0xFFFFD1DC),
                        // Pastel Red
                        SizedBox(
                          width: 20,
                        ),

                        // Orange
                        SizedBox(
                          width: 20,
                        ),
                        categorySelect("Work", 0xFFADD8E6),
                        // Light Blue (representing 'blue' as per your request)
                        SizedBox(
                          width: 20,
                        ),
                        categorySelect("Design", 0xFF00008B),
                        // Dark Blue
                        SizedBox(
                          width: 20,
                        ),
                        categorySelect("Run", 0xFFADD8E6),
                        // Light Blue
                        SizedBox(
                          width: 20,
                        ),
                        categorySelect("Exercise", 0xFF26C6DA),
                        // Keeping original or specify a new one
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    edit ? Button() : SizedBox(),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget Button() {
    return InkWell(
      onTap: () {
        FirebaseFirestore.instance.collection("Todo").doc(widget.id).update({
          "title": titleController.text,
          "task": type,
          "category": category,
          "description": descriptionController.text,
        });
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const HomePage();
        }));
      },
      child: Container(
        height: 55,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.white, Colors.blueAccent]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            "Update Todo",
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget description() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.black, Colors.grey]),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: descriptionController,
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),
        maxLength: null,
        decoration: InputDecoration(
          enabled: edit,
          border: InputBorder.none,
          hintText: "Enter Task Description",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          contentPadding: EdgeInsets.only(
            left: 15,
            right: 15,
            top: 15,
            bottom: 15,
          ),
        ),
      ),
    );
  }

  Widget taskSelect(String label, int color) {
    return InkWell(
      onTap: edit
          ? () {
              setState(() {
                type = label;
              });
            }
          : null,
      child: Chip(
        backgroundColor: type == label ? Colors.white : Color(color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        label: Text(
          label,
          style: TextStyle(
            color: type == label ? Colors.black : Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        labelPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      ),
    );
  }

  Widget categorySelect(String label, int color) {
    return InkWell(
      onTap: edit
          ? () {
              setState(() {
                category = label;
              });
            }
          : null,
      child: Chip(
        backgroundColor: category == label ? Colors.white : Color(color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        label: Text(
          label,
          style: TextStyle(
            color: category == label ? Colors.black : Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        labelPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      ),
    );
  }

  Widget title() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.black, Colors.grey]),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: titleController,
        enabled: edit,
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Enter Task Title",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          contentPadding: EdgeInsets.only(
            left: 15,
            right: 15,
            top: 15,
            bottom: 15,
          ),
        ),
      ),
    );
  }

  Widget label(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 16.5,
        letterSpacing: 0.2,
      ),
    );
  }
}
