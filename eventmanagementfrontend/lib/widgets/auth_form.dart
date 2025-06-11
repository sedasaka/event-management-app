// lib/widgets/auth_form.dart
import 'package:flutter/material.dart';

enum UserRole { ORGANIZER, PARTICIPANT } // Entspricht den Backend-Rollen

class AuthForm extends StatefulWidget {
  final bool isLogin;
  final void Function(String username, String? email, String password, UserRole? role) onSubmit;

  const AuthForm({
    super.key,
    required this.isLogin,
    required this.onSubmit,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>(); // Für die Formular-Validierung
  String _username = '';
  String _email = '';
  String _password = '';
  UserRole _selectedRole = UserRole.PARTICIPANT; // Standardrolle für Registrierung

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate(); // Führt Validierung aus
    FocusScope.of(context).unfocus(); // Tastatur schließen

    if (isValid) {
      _formKey.currentState!.save(); // Speichert die Formularfelder
      widget.onSubmit(
        _username.trim(),
        widget.isLogin ? null : _email.trim(), // E-Mail nur bei Registrierung
        _password.trim(),
        widget.isLogin ? null : _selectedRole, // Rolle nur bei Registrierung
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                key: const ValueKey('username'),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 4) {
                    return 'Please enter at least 4 characters for username.';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(labelText: 'Username'),
                onSaved: (value) {
                  _username = value!;
                },
              ),
              if (!widget.isLogin) // E-Mail-Feld nur bei Registrierung
                TextFormField(
                  key: const ValueKey('email'),
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email address'),
                  onSaved: (value) {
                    _email = value!;
                  },
                ),
              TextFormField(
                key: const ValueKey('password'),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return 'Password must be at least 6 characters long.';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (value) {
                  _password = value!;
                },
              ),
              if (!widget.isLogin) // Rollenauswahl nur bei Registrierung
                DropdownButtonFormField<UserRole>(
                  value: _selectedRole,
                  decoration: const InputDecoration(labelText: 'Role'),
                  items: UserRole.values.map<DropdownMenuItem<UserRole>>((UserRole role) {
                    return DropdownMenuItem<UserRole>(
                      value: role,
                      child: Text(role.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (UserRole? newValue) {
                    setState(() {
                      _selectedRole = newValue!;
                    });
                  },
                ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _trySubmit,
                child: Text(widget.isLogin ? 'Login' : 'Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}