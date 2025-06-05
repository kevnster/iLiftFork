import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green[50]!,
              Colors.white,
            ]
          )
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24), 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch, 
              children: [
              Expanded(
                flex: 3, 
                child: Center(
                  child: Lottie.asset(
                    'assets/animations/lifting.json', // placeholder
                    repeat: true,
                    animate: true,
                  ),
                ),
              ),

              Text(
                'iLiftFork',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              
              // app tagline? 

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const SignupScreen())
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, 
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                child: const Text(
                  'Get started',
                  style: TextStyle(fontSize: 16),
                )
              ),

              const SizedBox(height: 16),

              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const LoginScreen())
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.green),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'I already have an account', 
                  style: TextStyle(fontSize: 16, color: Colors.green),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}