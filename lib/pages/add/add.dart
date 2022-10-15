import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gigaupload/const.dart';

class AddFilePage extends StatefulWidget {
  const AddFilePage({super.key});

  @override
  State<AddFilePage> createState() => _AddFilePageState();
}

class _AddFilePageState extends State<AddFilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("You can upload .png file and"),
            const Text("file size is not over 2MB."),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ["png"],
                  withData: true,
                );

                // has a file or not ?
                if (filePickerResult == null) {
                  Get.snackbar(
                    "Error",
                    "You didn't choose a file.",
                    icon: const Icon(Icons.error),
                  );
                } else {
                  log('pick = ${filePickerResult.files.length} files');
                  log('pick = ${filePickerResult.files.first.size} byte');

                  // is size over 2M ?
                  if (filePickerResult.files.first.size > 2000000) {
                    Get.snackbar(
                      "Error",
                      "You file is over 2MB, please choose other file",
                      icon: const Icon(Icons.error),
                    );
                  } else {
                    // upload
                    Uint8List? fileBytes = filePickerResult.files.first.bytes;

                    final timeStamp = DateTime.now().millisecondsSinceEpoch;
                    final fileName = filePickerResult.files.first.name;
                    final fileSize = filePickerResult.files.first.size;
                    final objectName = '${timeStamp}.png';
                    final path = '/${auth.currentUser!.uid}/${objectName}';
                    final storageRef = storage.ref(path);

                    try {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                CircularProgressIndicator(),
                                SizedBox(
                                  height: 16.0,
                                ),
                                Text("Uploading..."),
                              ],
                            ),
                          ),
                        ),
                      );

                      final task = storageRef.putData(fileBytes!, SettableMetadata(contentType: "image/png"));

                      task.asStream().listen((event) {
                        if (event.state == TaskState.success) {
                          storageRef.getDownloadURL().then((downloadUrl) {
                            final data = {
                              'created': timeStamp,
                              'filename': fileName,
                              'size': fileSize,
                              'object': path,
                              'url': downloadUrl,
                            };

                            // update meta data in firestore
                            firestore
                                .collection("files")
                                .doc(auth.currentUser!.uid)
                                .collection("items")
                                .doc('${timeStamp}')
                                .set(data);

                            Get.offAllNamed("/");
                          });
                        }
                      });
                    } catch (e) {
                      Get.snackbar(
                        "Something went wrong!",
                        "You file cannot upload, please try again later.",
                        icon: const Icon(Icons.error),
                      );
                    }
                  }
                }
              },
              child: const Text("Browse file and Upload ..."),
            ),
          ],
        ),
      ),
    );
  }
}
