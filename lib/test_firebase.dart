import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

class FirebaseTestPage extends StatefulWidget {
  @override
  _FirebaseTestPageState createState() => _FirebaseTestPageState();
}

class _FirebaseTestPageState extends State<FirebaseTestPage> {
  String _status = 'Testing Firebase connection...';
  
  @override
  void initState() {
    super.initState();
    _testFirebase();
  }

  Future<void> _testFirebase() async {
    try {
      // Test 1: Check if Firebase is initialized
      setState(() {
        _status = 'Step 1: Checking Firebase initialization...';
      });
      await Future.delayed(Duration(seconds: 1));
      
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      
      setState(() {
        _status = 'Step 1: ✅ Firebase initialized successfully\n\nStep 2: Testing Authentication...';
      });
      await Future.delayed(Duration(seconds: 1));
      
      // Test 2: Try anonymous authentication
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
        setState(() {
          _status += '\nStep 2: ✅ Anonymous auth successful (${userCredential.user?.uid})';
        });
      } catch (e) {
        setState(() {
          _status += '\nStep 2: ❌ Anonymous auth failed: $e';
        });
      }
      
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        _status += '\n\nStep 3: Testing Firestore connection...';
      });
      
      // Test 3: Try to access Firestore
      try {
        await FirebaseFirestore.instance
            .collection('test')
            .doc('connection_test')
            .set({'timestamp': FieldValue.serverTimestamp()});
            
        setState(() {
          _status += '\nStep 3: ✅ Firestore write successful';
        });
        
        // Try to read
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('test')
            .doc('connection_test')
            .get();
            
        setState(() {
          _status += '\nStep 3: ✅ Firestore read successful';
        });
        
      } catch (e) {
        setState(() {
          _status += '\nStep 3: ❌ Firestore failed: $e';
        });
      }
      
    } catch (e) {
      setState(() {
        _status = 'Firebase initialization failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Connection Test'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Firebase Connection Status:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _status,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _status = 'Retesting...';
                });
                _testFirebase();
              },
              child: Text('Retry Test'),
            ),
          ],
        ),
      ),
    );
  }
}