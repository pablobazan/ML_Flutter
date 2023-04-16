import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:ml_flutter/main.dart';

class ImageLabelingRealTimePage extends StatefulWidget {
  const ImageLabelingRealTimePage({Key? key}) : super(key: key);

  @override
  State<ImageLabelingRealTimePage> createState() =>
      _ImageLabelingRealTimePageState();
}

class _ImageLabelingRealTimePageState extends State<ImageLabelingRealTimePage> {
  late CameraController controller;
  CameraImage? img;
  bool isBusy = false;
  String result = "";
  dynamic imageLabeler;

  @override
  initState() {
    super.initState();
    final ImageLabelerOptions options =
        ImageLabelerOptions(confidenceThreshold: 0.5);
    imageLabeler = ImageLabeler(options: options);

    controller = CameraController(cameras[0], ResolutionPreset.high);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      controller.startImageStream((image) => {
            if (!isBusy) {isBusy = true, img = image, doImageLabeling()}
          });
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.stopImageStream();
    controller.dispose();
    super.dispose();
  }

  InputImage getInputImage() {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in img!.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(img!.width.toDouble(), img!.height.toDouble());

    final camera = cameras[0];
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    // if (imageRotation == null) return;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(img!.format.raw);
    // if (inputImageFormat == null) return null;

    final planeData = img!.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation!,
      inputImageFormat: inputImageFormat!,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    return inputImage;
  }

  doImageLabeling() async {
    result = "";
    InputImage inputImg = getInputImage();
    final List<ImageLabel> labels = await imageLabeler.processImage(inputImg);
    for (ImageLabel label in labels) {
      final String text = label.label;
      final double confidence = label.confidence;
      result += "$text   ${confidence.toStringAsFixed(2)}\n";
    }
    if (mounted) {
      setState(() {
        result;
        isBusy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Image Labeling Real Time'),
        ),
        body: Stack(
          children: [
            CameraPreview(controller),
            Container(
              margin: const EdgeInsets.only(left: 10, bottom: 10),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  result,
                  style: const TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            )
          ],
        ));
  }
}
