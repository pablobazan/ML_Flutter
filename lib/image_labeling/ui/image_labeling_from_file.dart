import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:ml_flutter/image_labeling/utils/pick_image_utils.dart';
import 'package:sizer/sizer.dart';

class ImageLabelingPage extends StatefulWidget {
  const ImageLabelingPage({super.key});

  @override
  State<ImageLabelingPage> createState() => _ImageLabelingPageState();
}

class _ImageLabelingPageState extends State<ImageLabelingPage> {
  late PickImageUtils _pickImageUtils;
  late ImageLabelerOptions _options;
  late ImageLabeler _imageLabel;
  List<ImageLabel> _labels = [];
  File? _image;

  @override
  void initState() {
    _pickImageUtils = PickImageUtils();
    _options = ImageLabelerOptions(confidenceThreshold: 0.5);
    _imageLabel = ImageLabeler(options: _options);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Labeling'),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 5.h,
            ),
            _image != null
                ? Image.file(
                    _image!,
                    width: 80.w,
                    height: 40.h,
                  )
                : Icon(
                    Icons.image,
                    size: 80.w,
                  ),
            SizedBox(height: 1.h),
            Text("Predictions:", style: TextStyle(fontSize: 16.sp)),
            Container(
              height: 20.h,
              width: 100.w,
              padding: EdgeInsets.only(top: 1.h),
              child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  shrinkWrap: true,
                  itemCount: _labels.length,
                  itemBuilder: (context, index) {
                    return Center(
                        child: Text(
                            "${_labels[index].label}:  ${(_labels[index].confidence * 100).floor()}%"));
                  }),
            ),
            const Spacer(),
            OutlinedButton(
                onPressed: () async {
                  final xfile = await _pickImageUtils.pickImageFromCamera();
                  if (xfile == null) return;
                  final labels = await _imageLabel
                      .processImage(InputImage.fromFilePath(xfile.path));

                  setState(() {
                    _image = File(xfile.path);
                    _labels = labels;
                  });
                },
                child: const Text("Pick image from camera")),
            OutlinedButton(
                onPressed: () async {
                  final xfile = await _pickImageUtils.pickImageFromGallery();
                  if (xfile == null) return;
                  final labels = await _imageLabel
                      .processImage(InputImage.fromFilePath(xfile.path));

                  setState(() {
                    _image = File(xfile.path);
                    _labels = labels;
                  });
                },
                child: const Text("Pick image from gallery")),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}
