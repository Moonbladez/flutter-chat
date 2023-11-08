import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _selectedImageFile;

  void _handleSelectImage() async {
    final selectedImage = await ImagePicker().pickImage(
      imageQuality: 50,
      maxWidth: 150,
      source: ImageSource.camera,
    );

    if (selectedImage == null) return;

    setState(() {
      _selectedImageFile = File(selectedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          backgroundImage: _selectedImageFile != null
              ? FileImage(_selectedImageFile!)
              : null,
        ),
        TextButton.icon(
          onPressed: _handleSelectImage,
          icon: const Icon(Icons.image),
          label: const Text("Add Image"),
        ),
      ],
    );
  }
}
