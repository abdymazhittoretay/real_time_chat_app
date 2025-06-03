import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome Page"), centerTitle: true),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                Icon(Icons.abc, size: 120.0),
                Text("Welcome to our app!", textAlign: TextAlign.center),
                Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.maxFinite, 50),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Theme.of(context).secondaryHeaderColor,
                  ),
                  onPressed: () {},
                  child: Text("Register"),
                ),
                SizedBox(height: 12.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.maxFinite, 50),
                  ),
                  onPressed: () {},
                  child: Text("Sign In"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
