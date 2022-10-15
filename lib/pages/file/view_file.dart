import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gigaupload/const.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

class ViewFilePage extends StatelessWidget {
  ViewFilePage({super.key});

  final String? fileId = Get.parameters['fileId'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: FutureBuilder(
          future: firestore.collection("files").doc(auth.currentUser!.uid).collection("items").doc(fileId).get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            // has error
            if (snapshot.hasError) {
              return const Center(
                child: Text("Error"),
              );
            }

            // has data
            if (snapshot.hasData) {
              final file = snapshot.data!;
              return InstaImageViewer(
                child: Image(
                  image: Image.network(file['url']).image,
                ),
              );
            }

            // loading

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
