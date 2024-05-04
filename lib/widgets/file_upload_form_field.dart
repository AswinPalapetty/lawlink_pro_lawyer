import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileUploadFormField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final void Function(File)? onFilePicked;

  const FileUploadFormField({
    super.key,
    this.hintText,
    this.labelText,
    this.onFilePicked,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FileUploadFormFieldState createState() => _FileUploadFormFieldState();
}

class _FileUploadFormFieldState extends State<FileUploadFormField> {
  File? _pickedFile;

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _pickedFile = File(result.files.single.path!);
      });

      if (widget.onFilePicked != null) {
        widget.onFilePicked!(_pickedFile!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickFile,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  _pickedFile != null ? _pickedFile!.path : '',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.attach_file),
            ],
          ),
        ),
      ),
    );
  }
}
