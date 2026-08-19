import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/theme/app_theme.dart';
import 'package:todoapp/utils/constants.dart';

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

  /// Matches TodoModel's priority values: 'Low' | 'Medium' | 'High'.
  late String priority;

  /// One of AppConstants.todoCategories.
  late String category;
  bool edit = false;

  @override
  void initState() {
    super.initState();
    final doc = widget.document ?? const <String, dynamic>{};

    titleController = TextEditingController(text: doc['title'] as String? ?? '');
    descriptionController =
        TextEditingController(text: doc['description'] as String? ?? '');

    // Firestore stores priority lowercase ('high'); the chips use title case.
    final storedPriority = (doc['priority'] as String? ?? '').toLowerCase();
    priority = AppConstants.priorityLevels.firstWhere(
      (p) => p.toLowerCase() == storedPriority,
      orElse: () => AppConstants.defaultPriority,
    );

    final storedCategory = doc['category'] as String? ?? '';
    category = AppConstants.todoCategories.contains(storedCategory)
        ? storedCategory
        : AppConstants.defaultCategory;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
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

                        FirebaseFirestore.instance
                            .collection("Todo")
                            .doc(widget.id)
                            .delete()
                            .then((_) {
                          if (mounted) Navigator.pop(context);
                        }).catchError((_) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Failed to delete task.')),
                            );
                          }
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
                    label("Priority"),
                    SizedBox(
                      height: 12,
                    ),
                    Wrap(
                      spacing: 20,
                      runSpacing: 10,
                      children: AppConstants.priorityLevels
                          .map((p) => prioritySelect(p))
                          .toList(),
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
                      spacing: 10,
                      runSpacing: 10,
                      children: AppConstants.todoCategories
                          .map((c) => categorySelect(c))
                          .toList(),
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

  Future<void> _updateTodo() async {
    final title = titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task title cannot be empty')),
      );
      return;
    }

    try {
      // Only the user-editable fields; status, priority casing, createdAt and
      // userId are left untouched so the document stays valid for TodoModel.
      await FirebaseFirestore.instance.collection("Todo").doc(widget.id).update({
        "title": title,
        "description": descriptionController.text.trim(),
        "category": category,
        "priority": priority.toLowerCase(),
      });
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update task. Please try again.')),
        );
      }
    }
  }

  Widget Button() {
    return InkWell(
      onTap: _updateTodo,
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

  Widget prioritySelect(String label) {
    final color = AppTheme.priorityColors[label] ?? Colors.blueGrey;
    return _selectableChip(
      label: label,
      color: color,
      selected: priority == label,
      onTap: () => setState(() => priority = label),
    );
  }

  Widget categorySelect(String label) {
    final color = AppTheme.categoryColors[label] ?? Colors.blueGrey;
    return _selectableChip(
      label: label,
      color: color,
      selected: category == label,
      onTap: () => setState(() => category = label),
    );
  }

  Widget _selectableChip({
    required String label,
    required Color color,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: edit ? onTap : null,
      child: Chip(
        backgroundColor: selected ? Colors.white : color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        label: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
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
