import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/user_image_picker.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _isLoading = false;

  String _error = "";
  File? _userImageFile;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    setState(() {
      _isLoading = false;
      _error = message;
    });
  }

  void _clearError() {
    setState(() {
      _isLoading = false;
      _error = "";
    });
  }

  void _validateAndSubmit(BuildContext context) async {
    final isValid = _formKey.currentState!.validate();

    if (!_isLogin && _userImageFile == null) {
      _showError("Please select a user image.");
      return;
    }

    if (!isValid) {
      return;
    }

    _clearError();

    try {
      setState(() {
        _isLoading = true;
      });
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        final user = FirebaseAuth.instance.currentUser;
        final storageRef = FirebaseStorage.instance
            .ref()
            .child("user_images")
            .child("${user!.uid}.jpg");

        await storageRef.putFile(_userImageFile!);
        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "username": _emailController.text,
          "email": _emailController.text,
          "image_url": imageUrl,
        });
      }
    } on FirebaseAuthException catch (e) {
      _showError(
          e.message ?? "An error occurred, please check your credentials!");
    } catch (error) {
      _showError("An error occurred");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: const FlutterLogo(
                  size: 100,
                ),
              ),
              Card(
                margin: const EdgeInsets.all(18),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isLogin)
                            UserImagePicker(
                              onImageSelect: (File selectedImage) {
                                _userImageFile = selectedImage;
                              },
                            ),
                          TextFormField(
                            autocorrect: false,
                            controller: _emailController,
                            decoration:
                                const InputDecoration(labelText: 'Email'),
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) => value!.trim().isEmpty ||
                                    !value.contains('@') ||
                                    !value.contains('.') ||
                                    value.length < 5
                                ? "Please enter a valid email"
                                : null,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              helperText: "At least 7 characters",
                            ),
                            obscureText: true,
                            validator: (value) =>
                                value!.trim().isEmpty || value.trim().length < 7
                                    ? "Please enter a valid password"
                                    : null,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (_isLoading)
                                const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              if (!_isLoading)
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isLogin = !_isLogin;
                                    });
                                  },
                                  child: Text(
                                    _isLogin
                                        ? "Create an account"
                                        : "I already have an account",
                                  ),
                                ),
                              if (!_isLoading)
                                ElevatedButton(
                                  onPressed: () {
                                    _validateAndSubmit(context);
                                  },
                                  child: Text(
                                    _isLogin ? "Login" : "Signup",
                                  ),
                                ),
                            ],
                          ),
                          if (_error.isNotEmpty)
                            const SizedBox(
                              height: 12,
                            ),
                          Text(
                            _error,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
