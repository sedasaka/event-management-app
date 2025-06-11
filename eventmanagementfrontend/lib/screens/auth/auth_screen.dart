// lib/screens/auth/auth_screen.dart
import 'package:flutter/material.dart';
import 'package:eventmanagementfrontend/widgets/auth_form.dart';
import 'package:eventmanagementfrontend/screens/events/event_list_screen.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;

  void _toggleForm() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _handleAuthSubmit(String username, String? email, String password, UserRole? role) {
    print('Form Submitted: Username: $username, Email: $email, Password: $password, Role: $role, IsLogin: $_isLogin');
    // TODO: Call API (später)
    
    // Simuliere erfolgreichen Login/Registrierung und navigiere zur EventListScreen
    // In einer echten App würde dies NACH einem erfolgreichen API-Call geschehen
    Navigator.of(context).pushReplacement( // pushReplacement, um AuthScreen aus dem Stack zu entfernen
      MaterialPageRoute(builder: (ctx) => const EventListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Register'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AuthForm(
                isLogin: _isLogin,
                onSubmit: _handleAuthSubmit, // Übergebe die neue Handler-Funktion
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _toggleForm,
                child: Text(_isLogin
                    ? 'Don\'t have an account? Register'
                    : 'Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}