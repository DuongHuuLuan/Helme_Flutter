import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_flutter/services/auth_services.dart';
import 'package:app_flutter/screens/auth/auth_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  final authServices = AuthServices();
  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     'Tài khoản',
      //     style: TextStyle(fontWeight: FontWeight.bold),
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.person, size: 50),
              ),
              const SizedBox(height: 16),
              Text(
                user.email ?? 'No Email',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                      email: user.email!,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: const Text(
                          'Email đặt lại mật khẩu đã được gửi!',
                        ),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('lỗi $e')));
                  }
                },
                icon: Icon(Icons.lock),
                label: const Text('ĐỔi mật khẩu'),
              ),

              // nút đăng xuất
              ElevatedButton.icon(
                icon: Icon(Icons.logout),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[300],
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return AuthScreen();
                      },
                    ),
                  );
                },
                label: Text(
                  'Đăng xuất',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
