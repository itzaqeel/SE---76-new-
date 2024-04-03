import 'dart:convert';

// import 'package:file_picker/file_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../AR/ar_mystery_box_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bottle Detector',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const mlModel(title: 'Bottle Detector'),
    );
  }
}

///this is the home page
class mlModel extends StatefulWidget {
  const mlModel({super.key, required this.title});

  final String title;

  @override
  State<mlModel> createState() => _mlModelState();
}

class _mlModelState extends State<mlModel> {
  ///results will store in this map
  Map results = {};

  ///file path for the video
  String? _filePath;

  ///to check the app is loading or not
  bool isLoading = false;

  ///this variable may not needed.
  bool isUploaded = false;

  ///text controller for the ip field
  final controller = TextEditingController();

  ///this function will pick the video from the local storage.
  Future<void> _pickVideo() async {
    try {
      String? filePath = await FilePicker.platform
          .pickFiles(
            type: FileType.video,
            allowMultiple: false,
          )
          .then((result) => result?.files.single.path);

      if (filePath != null) {
        setState(() {
          ///start the loading animation and set the video file path
          isLoading = true;
          _filePath = filePath;
        });
      }
    } catch (e) {
      setState(() {
        ///is there is an error while fetching the video file...
        isLoading = false;
        results = {'error': e.toString()};
      });
    }
  }

  ///this is the main method calling the api for inference.
  ///this takes the server ip as an input
  Future<void> _apiCall(String ip) async {
    if (_filePath != null) {
      var url = Uri.parse('http://$ip:5000/detect'); // Adjust the URL

      // Create multipart request
      var request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('file', _filePath!));

      try {
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          //if the upload is sucess and the response is recieved....
          isUploaded = true;
          List apiResponse = _parseJsonList(response.body);
          results = _getObjects(apiResponse);
          setState(() {
            isLoading = false;
            //if needed the response.body can be prented to the cmd from here..
          });
        } else {
          setState(() {
            //if anythig other than status 200 is recieved, this will trigger the error
            isLoading = false;
            results = {'error': response.reasonPhrase};
          });
        }
      } catch (e) {
        setState(() {
          //if there is any error other than the 400 this will trigger
          isLoading = false;
          results = {'error': e.toString()};
        });
      }
    }
  }

  ///this function is for parse the response and get the list
  List<Map<String, dynamic>> _parseJsonList(String jsonString) {
    List<Map<String, dynamic>> list = [];

    List<dynamic> jsonArray = json.decode(jsonString);

    for (var jsonMap in jsonArray) {
      if (jsonMap is Map<String, dynamic>) {
        list.add(jsonMap);
      }
    }

    return list;
  }

  ///this function returns the desired output as a map
  Map _getObjects(List list) {
    bool bottleDisposed = false;
    bool dustbin = false;
    bool empty = false;
    bool plasticBottle = false;

    for (Map detections in list) {
      for (List objects in detections['objects']) {
        final classification = objects[4].toString();
        switch (classification) {
          case "Dustbin":
            dustbin = true;
            break;
          case "Bottle-Disposed":
            bottleDisposed = true;
            if (bottleDisposed) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ArMysteryBoxScreen()),
              );
            }
            break;
          case "Empty":
            empty = true;
            break;
          case "Plastic-Bottle":
            plasticBottle = true;
            break;
        }
      }
    }
    return {
      "Dustbin": dustbin,
      "Bottle-Disposed": bottleDisposed,
      "Empty": empty,
      "Plastic-Bottle": plasticBottle,
    };
  }

  ///this is to capture the video through the image_picker plugin
  Future<void> _captureVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      setState(() {
        isLoading = true;
        _filePath = video.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  //get the server IP
                  const Text("Server IP"),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : results.isNotEmpty
                      ? Center(
                          child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Detections: $results",
                            style: const TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ))
                      : const SizedBox(),
            )
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //this button is for capture video
            FloatingActionButton(
              onPressed: () async {
                await _captureVideo();
                if (controller.text.isNotEmpty) {
                  await _apiCall(controller.text);
                }
              },
              tooltip: 'Capture',
              child: const Icon(Icons.camera),
            ),
            const SizedBox(
              width: 20.0,
            ),
            //this button is to pick a video file
            FloatingActionButton(
              onPressed: () async {
                await _pickVideo();
                if (controller.text.isNotEmpty) {
                  await _apiCall(controller.text);
                }
              },
              tooltip: 'Pick',
              child: const Icon(Icons.download),
            ),
            // const SizedBox(
            //   width: 20.0,
            // ),
          ],
        ),
      ),
    );
  }
}
