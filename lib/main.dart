import 'dart:io';
import 'dart:ui';


import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import 'firebase_options.dart';
late List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();


  // 1. Khởi động trạm Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Thu thập mọi lỗi do Flutter (UI, Logic) gây ra
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // 3. Thu thập mọi lỗi chạy ngầm (Asynchronous errors)
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CameraScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;
  late Interpreter interpreter;
  List<String> labels = [];
  bool isModelLoaded = false;

  String result = "Chưa nhận diện";

  @override
  void initState() {
    super.initState();
    initCamera();
    loadModel();
  }

  Future<void> initCamera() async {
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    await controller.initialize();
    setState(() {});
  }

  Future<void> loadModel() async {
    try {
      print("🚀 Loading model...");

      interpreter = await Interpreter.fromAsset('assets/model.tflite');

      print("✅ Model loaded");
      
      // Debug: In thông tin về model
      print("📊 Input shape: ${interpreter.getInputTensors()}");
      print("📊 Output shape: ${interpreter.getOutputTensors()}");

      final labelData = await rootBundle.loadString('assets/labels.txt');

      print("✅ Labels loaded");

      labels = labelData.split('\n').where((e) => e.isNotEmpty).toList();
      
      print("🏷️ Số lượng labels: ${labels.length}");
      print("🏷️ Labels: $labels");

      setState(() {
        isModelLoaded = true;
      });

      print("🔥 Ready!");
    } catch (e) {
      print("❌ ERROR LOAD MODEL: $e");
    }
  }

  Future<void> captureAndPredict() async {
    try {
      final image = await controller.takePicture();
      final bytes = await File(image.path).readAsBytes();

      img.Image? oriImage = img.decodeImage(bytes);
      if (oriImage == null) {
        print("❌ Không thể decode ảnh");
        return;
      }

      img.Image resized = img.copyResize(oriImage, width: 224, height: 224);

      var input = List.generate(
        1,
            (i) => List.generate(
          224,
              (y) => List.generate(
            224,
                (x) {
                  var pixel = resized.getPixel(x, y);

                  return [
                    pixel.r / 255.0,
                    pixel.g / 255.0,
                    pixel.b / 255.0,
                  ];
            },
          ),
        ),
      );

      var output = List.generate(1, (_) => List.filled(labels.length, 0.0));

      interpreter.run(input, output);

      List<double> resultList = List<double>.from(output[0]);
      
      // In ra tất cả kết quả để debug
      print("🔍 Kết quả dự đoán:");
      for (int i = 0; i < labels.length; i++) {
        print("${labels[i]}: ${(resultList[i] * 100).toStringAsFixed(2)}%");
      }

      int maxIndex = resultList.indexWhere(
              (e) => e == resultList.reduce((a, b) => a > b ? a : b));

      double confidence = resultList[maxIndex] * 100;

      setState(() {
        result = "${labels[maxIndex]} (${confidence.toStringAsFixed(1)}%)";
      });
    } catch (e) {
      print("❌ Lỗi khi dự đoán: $e");
      setState(() {
        result = "Lỗi: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isModelLoaded) {
      return Scaffold(
        body: Center(child: Text("Đang load AI...")),
      );
    }
    if (!controller.value.isInitialized) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text("AI Nhận diện rác")),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(controller),
          ),
          SizedBox(height: 20),
          Text(
            "Kết quả: $result",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: isModelLoaded ? captureAndPredict : null,
            child: Text("Chụp & Nhận diện"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    interpreter.close();
    super.dispose();
  }
}