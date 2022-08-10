import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Row(
            children: [
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.openPaymentApp,
                  child: const Text('Open Payment App'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.clearResponse,
                  child: const Text('Clear Error'),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
          GetBuilder<HomeController>(
            builder: (controller) => Column(
              children: [
                const Text('Flutter Error'),
                Text(controller.flutterResponse),
              ],
            ),
          ),
          const Text('Pinelabs response'),
          StreamBuilder(
            stream: controller.pinelabSdk.stream,
            builder: (context, snapshot) {
              return Text(snapshot.data?.toString() ?? '');
            },
          ),
        ],
      ),
    );
  }
}
