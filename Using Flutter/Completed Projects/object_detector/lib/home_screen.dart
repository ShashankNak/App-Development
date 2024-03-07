import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:object_detector/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isWorking = false;
  String result = "Yayaya";
  late CameraController cameraController;
  CameraImage? imgCamera;
  bool isStop = true;

  void loadModel() async {
    await Tflite.loadModel(
        model: "assets/mobilenet_v1_1.0_224.tflite",
        labels: "assets/mobilenet_v1_1.0_224.txt");
  }

  void initCamera() {
    isStop = false;
    if (!isStop) {
      cameraController =
          CameraController(cameras[0], ResolutionPreset.veryHigh);
      cameraController.initialize().then((value) {
        if (!mounted) {
          return;
        }

        setState(() {
          cameraController.startImageStream((image) {
            if (!isWorking) {
              isWorking = true;
              imgCamera = image;
              runModelOnStreamScreen();
            }
          });
        });
      });
    }
  }

  void runModelOnStreamScreen() async {
    if (imgCamera != null) {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: imgCamera!.planes.map(
          (e) {
            return e.bytes;
          },
        ).toList(),
        imageHeight: imgCamera!.height,
        imageWidth: imgCamera!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.1,
        asynch: true,
      );
      result = "";

      for (dynamic element in recognitions!) {
        result += element['label'] +
            " " +
            (element["confidence"] as double).toStringAsFixed(2) +
            "\n\n";
      }
      setState(() {
        result;
        isWorking = false;
      });
    }
  }

  void stopImageStream() async {
    if (!isStop) {
      cameraController.stopImageStream();
      setState(() {
        imgCamera = null;
        result = "";
        isStop = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  @override
  void dispose() async {
    super.dispose();
    await Tflite.close();
    cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Object Detection",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.white,
                fontSize: size.width / 20,
                fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          actions: [
            if (!isStop)
              IconButton(
                onPressed: () {
                  stopImageStream();
                },
                icon: const Icon(
                  Icons.stop,
                  color: Colors.white,
                ),
              )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height / 30,
              ),
              Center(
                child: MaterialButton(
                  onPressed: () {
                    initCamera();
                  },
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimaryContainer
                      .withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: SizedBox(
                    height: size.height / 2,
                    width: size.width / 1.2,
                    child: imgCamera == null
                        ? SizedBox(
                            height: size.height / 60,
                            width: size.width / 5,
                            child: const Icon(Icons.photo_camera),
                          )
                        : AspectRatio(
                            aspectRatio: cameraController.value.aspectRatio,
                            child: CameraPreview(cameraController),
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height / 30,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  result,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: size.width / 10,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              )
            ],
          ),
        ));
  }
}
