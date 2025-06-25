import 'dart:io';
import 'package:flutter/foundation.dart'; // für kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../theme/theme.dart';
import '../../core/services/db_service.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/storage_service.dart';
import 'dart:developer' as developer;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthService _authService = AuthService();
  final DBService _dbService = DBService();
  final StorageService _storageService = StorageService();

  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();

  String? _userId;
  String _username = '';
  String _avatarUrl = '';
  bool _notifications = true;

  XFile? _newAvatarFile;
  bool _isLoading = true;

  int _easterEggCounter = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _logout() async {
    try {
      await _authService.signOut();
      // Optional: Navigate to login screen or handle logout state
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _loadUserData() async {
    final user = _authService.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final userId = user.uid;

    // Lade Daten aus DB
    final snapshot = await _dbService.getUserData(userId);
    final data = snapshot.value as Map?;

    // Lade Avatar direkt aus Firebase Storage
    String? avatarUrlFromStorage;
    try {
      avatarUrlFromStorage = await _storageService.getAvatarUrl(userId);
      developer.log('Avatar URL from storage: $avatarUrlFromStorage');
    } catch (e) {
      avatarUrlFromStorage = null; // kein Avatar gefunden
    }

    setState(() {
      _userId = userId;
      _username = data?['username'] ?? '';
      _avatarUrl = avatarUrlFromStorage ?? (data?['avatar'] ?? '');
      _notifications = data?['notifications'] ?? true;
      _nameController.text = _username;
      _isLoading = false;
    });
  }

  Future<void> _updateUsername(String newName) async {
    if (_userId != null) {
      await _dbService.updateUsername(_userId!, newName);
    }
  }

  Future<void> _updateNotifications(bool value) async {
    if (_userId != null) {
      await _dbService.updateNotifications(_userId!, value);
    }
  }

  Future<void> _pickImage() async {
    developer.log('Picking image...');
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null && _userId != null) {
      setState(() {
        _newAvatarFile = picked;
      });
      developer.log('Image picked: ${picked.path}');
      final downloadUrl = await _storageService.uploadAvatar(_userId!, picked);
      setState(() {
        _avatarUrl = downloadUrl;
      });
      await _dbService.updateAvatar(_userId!, downloadUrl);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    ImageProvider? avatarImage;
    if (_newAvatarFile != null) {
      avatarImage =
          kIsWeb
              ? (_avatarUrl.isNotEmpty ? NetworkImage(_avatarUrl) : null)
              : FileImage(File(_newAvatarFile!.path));
    } else {
      avatarImage = (_avatarUrl.isNotEmpty) ? NetworkImage(_avatarUrl) : null;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF2F7F3),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color(0xFFF2F7F3),
        centerTitle: true,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Text(
            "Settings",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            // Avatar Section
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Change Avatar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.primaryContainerColor,
                      backgroundImage: avatarImage,
                      child:
                          avatarImage == null
                              ? const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 32,
                              )
                              : null,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Username Section
            GestureDetector(
              onTap: () {
                setState(() {
                  _easterEggCounter++;
                  if (_easterEggCounter >= 7) {
                    _easterEggCounter = 0;
                    showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: const Text("🧙‍♂️ Seepold has appeared!"),
                            content: Image.asset("assets/images/seepold.png"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Hide"),
                              ),
                            ],
                          ),
                    );
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 12.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Username',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 150,
                      child: TextField(
                        controller: _nameController,
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                        onChanged: (value) {
                          setState(() => _username = value);
                        },
                        onSubmitted: _updateUsername,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Notifications Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Switch(
                    value: _notifications,
                    activeColor: AppColors.primaryColor,
                    onChanged: (value) {
                      setState(() => _notifications = value);
                      _updateNotifications(value);
                    },
                  ),
                ],
              ),
            ),
            // Add spacing before logout button
            const SizedBox(height: 40),
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text(
                            'Are you sure you want to logout?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _logout();
                              },
                              child: const Text(
                                'Logout',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
