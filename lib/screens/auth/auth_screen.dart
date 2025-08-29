import 'package:app_flutter/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:app_flutter/services/auth_services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _authservices = AuthServices();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (_isLogin) {
      await _authservices.signIn(email, password);
    } else {
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();
      await _authservices.signUp(email, password, name, phone);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(_isLogin ? 'Đăng nhập' : 'Đăng ký')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (!_isLogin)
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Tên'),
                  validator: (value) => value != null && value.isNotEmpty
                      ? null
                      : 'Nhập tên sai cần nhập lại thông tin',
                ),

              // ),
              if (!_isLogin)
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Số điện thoại'),
                  validator: (value) => value != null && value.length >= 10
                      ? null
                      : 'Số điện thoại không chính xác',
                ),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value != null && value.contains('@')
                    ? null
                    : 'Email không hợp lệ',
              ),

              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Mật khẩu'),
                validator: (value) => value != null && value.length >= 6
                    ? null
                    : 'Mật khẩu không hợp lệ',
              ),

              ElevatedButton(
                onPressed: _submit,
                child: Text(_isLogin == true ? 'Đăng nhập' : 'Đăng ký'),
              ),

              TextButton(
                onPressed: () => setState(() {
                  _isLogin = !_isLogin;
                }),
                child: Text(
                  _isLogin
                      ? 'Chưa có tài khoản? Đăng ký'
                      : 'Đã có tài khoản? Đăng nhập',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
