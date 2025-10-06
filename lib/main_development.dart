import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/environment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize app configuration for development
  EnvironmentConfig.setEnvironment(Environment.development);
  EnvironmentConfig.printEnvironmentInfo();
  
  // Run the app
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'CSR CRM - Development',
        debugShowCheckedModeBanner: true,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('CSR CRM - Development'),
            backgroundColor: Colors.orange,
          ),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.construction,
                  size: 64,
                  color: Colors.orange,
                ),
                SizedBox(height: 16),
                Text(
                  'CSR CRM',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Development Environment',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Flutter project initialized successfully!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
