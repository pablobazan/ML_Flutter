import 'package:flutter/material.dart';
import 'package:ml_flutter/image_labeling/ui/image_labeling_from_file.dart';
import 'package:ml_flutter/image_labeling/ui/image_labeling_real_time.dart';
import 'package:ml_flutter/main.dart';

class Routes {
  static const homePage = '/homePage';
  static const imageLabelingPageFromFile = '/imageLabelingFromFilePage';
  static const imageLabelingRealTimePage = '/ImageLabelingRealTimePage';
}

class Pages {
  static final Map<String, Widget Function(BuildContext)> routes = {
    Routes.homePage: (_) => const HomePage(),
    Routes.imageLabelingPageFromFile: (_) => const ImageLabelingPage(),
    Routes.imageLabelingRealTimePage: (_) => const ImageLabelingRealTimePage()
  };
}
