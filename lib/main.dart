import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ml_flutter/core/routes/routes.dart';
import 'package:sizer/sizer.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: ((context, orientation, deviceType) {
      return MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        routes: Pages.routes,
        initialRoute: Routes.homePage,
      );
    }));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ML Flutter'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OutlinedButton(
                  onPressed: () =>
                      goTo(context, Routes.imageLabelingPageFromFile),
                  child: const Text("Image labeling from file")),
              OutlinedButton(
                  onPressed: () =>
                      goTo(context, Routes.imageLabelingRealTimePage),
                  child: const Text("Image labeling real time")),
            ],
          ),
        ));
  }

  goTo(BuildContext context, String page) {
    Navigator.pushNamed(context, page);
  }
}
