import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker(
      {super.key, required this.onPickedImage, required this.imagesize});

  final void Function(File pickedImage) onPickedImage;
  final double imagesize;
  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _image;

  Future _getImageFromCamera() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 150,
    );
    if (image == null) {
      return;
    }

    setState(() {
      _image = File(image.path);
    });

    widget.onPickedImage(_image!);
  }

  Future _getImageFromGallery() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 150,
    );
    if (image == null) {
      return;
    }
    setState(() {
      _image = File(image.path);
    });

    widget.onPickedImage(_image!);
  }

  void _showOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Padding(
            padding:
                const EdgeInsets.only(bottom: 10, top: 10, left: 30, right: 30),
            child: Row(
              children: [
                GestureDetector(
                  child: const Icon(
                    Icons.camera_alt,
                    size: 50,
                  ),
                  onTap: () {
                    _getImageFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(width: 100.0),
                GestureDetector(
                  child: const Icon(
                    Icons.folder_copy_rounded,
                    size: 50,
                  ),
                  onTap: () {
                    _getImageFromGallery();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // File? _pickedImageFile;

  // void _pickImage() async {
  //   final pickedImage = await ImagePicker().pickImage(
  //     source: ImageSource.camera,
  //     imageQuality: 50,
  //     maxWidth: 150,
  //   );
  //   if (pickedImage == null) {
  //     return;
  //   }

  //   setState(() {
  //     _pickedImageFile = File(pickedImage.path);
  //   });

  //   widget.onPickedImage(_pickedImageFile!);
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: widget.imagesize,
          foregroundImage: _image != null ? FileImage(_image!) : null,
          child: const Icon(Icons.person),
        ),
        TextButton.icon(
          onPressed: _showOptionsDialog,
          label: Text(
            'Add Image (Needed)',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          icon: const Icon(Icons.image),
        ),
      ],
    );
  }
}
