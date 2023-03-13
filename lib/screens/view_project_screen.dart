import 'dart:developer';

import 'package:client_app/models/project.dart';
import 'package:client_app/screens/add_update_review_screen.dart';
import 'package:client_app/view_state_mixin.dart';
import 'package:flutter/material.dart';

class ViewProjectScreen extends StatefulWidget {
  const ViewProjectScreen({super.key, required this.project});
  final Project project;

  @override
  State<ViewProjectScreen> createState() => _ViewProjectScreenState();
}

class _ViewProjectScreenState extends State<ViewProjectScreen>
    with ViewStateMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        setBusy();

        setIdle();
      } catch (e) {
        log("Error in ViewProjectScreen Init", error: e);
        setError();
        rethrow;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Text("hi")),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AddUpdateReview(project: widget.project)));
          },
          icon: const Icon(Icons.add),
          label: Text("Add Reivew"),
        ));
  }
}
