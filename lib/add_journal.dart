import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddJournalScreen extends StatefulWidget {
  const AddJournalScreen({super.key});

  @override
  State<AddJournalScreen> createState() => _AddJournalScreenState();
}

class _AddJournalScreenState extends State<AddJournalScreen> {
  final _contentController = TextEditingController();
  final List<File> _images = [];
  bool _isSubmitting = false;

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(imageQuality: 75);

    if (picked.isNotEmpty) {
      setState(() {
        _images.addAll(
          picked.take(3 - _images.length).map((e) => File(e.path)),
        );
      });
    }
  }

  Future<List<String>> _uploadImages(String userId, String docId) async {
    final List<String> urls = [];
    for (int i = 0; i < _images.length; i++) {
      final ref = FirebaseStorage.instance.ref(
        'journal_photos/$userId/$docId/photo_$i.jpg',
      );
      final uploadTask = await ref.putFile(_images[i]);
      final url = await uploadTask.ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }

  Future<void> _submit() async {
    if (_contentController.text.trim().isEmpty && _images.isEmpty) return;

    setState(() => _isSubmitting = true);
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final docRef = FirebaseFirestore.instance.collection('journals').doc();

    try {
      final photoUrls = await _uploadImages(uid, docRef.id);
      final now = Timestamp.now();

      await docRef.set({
        'id': docRef.id,
        'userId': uid,
        'coupleId': null, // Replace with actual couple ID if needed
        'content': _contentController.text.trim(),
        'photos': photoUrls,
        'createdAt': now,
        'updatedAt': now,
      });

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save: ${e.toString()}")),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Journal")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _contentController,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: "What's on your mind?",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._images.map(
                  (img) => Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Image.file(
                        img,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _images.remove(img);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                if (_images.length < 3)
                  GestureDetector(
                    onTap: _pickImages,
                    child: Container(
                      height: 100,
                      width: 100,
                      color: Colors.grey[300],
                      child: const Icon(Icons.add_a_photo),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isSubmitting ? null : _submit,
              icon: const Icon(Icons.check),
              label: _isSubmitting
                  ? const CircularProgressIndicator()
                  : const Text("Save Journal"),
            ),
          ],
        ),
      ),
    );
  }
}
