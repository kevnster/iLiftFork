import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iLiftFork',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('iLiftFork'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ), 

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to iLifeFork!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            const Text(
              'Testing Firebase connection...',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () async {
                try {
                  final firestore = FirebaseFirestore.instance; 
                  
                  await firestore.collection('test').doc('test-doc').set(
                    {
                      'message': 'Hello, iLiftFork!',
                      'timestamp': FieldValue.serverTimestamp()}
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error writing to Firestore: ${e.toString()}'))
                  );
                }
              }, 
              child: const Text('Testing Firestore write'),
            ),

            ElevatedButton(
              onPressed: () async {
                try {
                  final firestore = FirebaseFirestore.instance; 
                  final doc = await firestore.collection('test').doc('test-doc').get();

                  if (doc.exists) {
                    final data = doc.data() as Map<String, dynamic>;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Firestore read successful; message: ${data['message']} at time: ${data['timestamp'].toDate().toString() ?? 'No timestamp'}'
                          ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Document does not exist. Try writing to it first...'),
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error reading from Firestore: ${e.toString()}')
                    )
                  );
                }
              },
              child: const Text('Testing Firestore read'),
            )
          ],
        ),
      ),
    );
  }
}