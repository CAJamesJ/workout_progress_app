import 'package:flutter/material.dart';

class FoodTrackingPage extends StatelessWidget {
  const FoodTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('Log your food here.'),
        ],
      ),
    );
  }
}
