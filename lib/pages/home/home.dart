import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gigaupload/const.dart';
import 'package:uni_links/uni_links.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> initUniLinks() async {
    unilinkStreamSubscription = uriLinkStream.listen((Uri? uri) {
      // Use the uri and warn the user, if it is not correct
      log('${uri}');
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
      log('not found link');
    });
  }

  @override
  void initState() {
    super.initState();
    initUniLinks();
  }

  @override
  void dispose() {
    super.dispose();
    unilinkStreamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giga Image Upload"),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) => Get.offAllNamed("/signin"));
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection("files")
            .doc(auth.currentUser!.uid)
            .collection("items")
            .orderBy('created', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // has error
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          }

          // show file list
          if (snapshot.hasData) {
            final files = snapshot.data?.docs;
            if (files!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text("Your space is empty!"),
                    SizedBox(height: 8.0),
                  ],
                ),
              );
            } else {
              return GridView.builder(
                itemCount: files.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () => Get.toNamed("/file/${files[index].id}"),
                    child: GridTile(
                      child: CachedNetworkImage(
                        imageUrl: files[index]['url'],
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => const SizedBox(
                          width: 200,
                          height: 200,
                          child: Icon(Icons.error),
                        ),
                      ),
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (context.width > 720) ? 4 : 2,
                ),
              );
            }
          }

          // progress
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed("/add"),
        child: const Icon(Icons.add),
      ),
    );
  }
}
