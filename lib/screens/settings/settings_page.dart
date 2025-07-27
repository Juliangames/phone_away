import 'dart:io';
import 'package:flutter/foundation.dart'; // für kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../theme/theme.dart';
import '../../core/services/db_service.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/helpers/error_handler.dart';
import 'settings_constants.dart';
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
  String _username = AppStrings.defaultUsername;
  String _avatarUrl = AppStrings.defaultAvatar;
  bool _notifications = AppStrings.defaultNotifications;

  XFile? _newAvatarFile;
  bool _isLoading = true;

  int _easterEggCounter = AppValues.easterEggResetCount;

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
          SnackBar(
            content: Text(
              '${SettingsConstants.logoutFailedPrefix}${e.toString()}',
            ),
          ),
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

    try {
      // Use ErrorHandler for consistent timeout handling
      await ErrorHandler.executeWithErrorHandling(() async {
        // Lade Daten aus DB
        final snapshot = await _dbService.getUserData(userId);
        final data = snapshot.value as Map?;

        // Lade Avatar direkt aus Firebase Storage
        String? avatarUrlFromStorage;
        try {
          avatarUrlFromStorage = await _storageService.getAvatarUrl(userId);
          developer.log(
            '${SettingsConstants.avatarUrlFromStorageLog}$avatarUrlFromStorage',
          );
        } catch (e) {
          avatarUrlFromStorage = null; // kein Avatar gefunden
        }

        setState(() {
          _userId = userId;
          _username =
              data?[AppStrings.usernameKey] ?? AppStrings.defaultUsername;
          _avatarUrl =
              avatarUrlFromStorage ??
              (data?[AppStrings.avatarKey] ?? AppStrings.defaultAvatar);
          _notifications =
              data?[AppStrings.notificationsKey] ??
              AppStrings.defaultNotifications;
          _nameController.text = _username;
          _isLoading = false;
        });
      });
    } catch (e) {
      // Show error message and provide fallback
      if (mounted) {
        ErrorHandler.showErrorSnackBar(context, e);

        // Set fallback values
        setState(() {
          _userId = userId;
          _username = AppStrings.defaultUsername;
          _avatarUrl = AppStrings.defaultAvatar;
          _notifications = AppStrings.defaultNotifications;
          _nameController.text = _username;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateUsername(String newName) async {
    if (_userId != null) {
      try {
        await ErrorHandler.executeWithErrorHandling(() async {
          await _dbService.updateUsername(_userId!, newName);
        });
      } catch (e) {
        if (mounted) {
          ErrorHandler.showErrorSnackBar(context, e);
        }
      }
    }
  }

  Future<void> _updateNotifications(bool value) async {
    if (_userId != null) {
      try {
        await ErrorHandler.executeWithErrorHandling(() async {
          await _dbService.updateNotifications(_userId!, value);
        });
      } catch (e) {
        if (mounted) {
          ErrorHandler.showErrorSnackBar(context, e);
          // Revert the switch state on error
          setState(() {
            _notifications = !value;
          });
        }
      }
    }
  }

  Future<void> _pickImage() async {
    developer.log(SettingsConstants.pickingImageLog);

    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null && _userId != null) {
        setState(() {
          _newAvatarFile = picked;
        });
        developer.log('${SettingsConstants.imagePickedLog}${picked.path}');

        await ErrorHandler.executeWithErrorHandling(() async {
          final downloadUrl = await _storageService.uploadAvatar(
            _userId!,
            picked,
          );
          setState(() {
            _avatarUrl = downloadUrl;
          });
          await _dbService.updateAvatar(_userId!, downloadUrl);
        });
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showErrorSnackBar(context, e);
        // Revert avatar file on error
        setState(() {
          _newAvatarFile = null;
        });
      }
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        toolbarHeight: AppDimensions.appBarHeight,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(top: AppDimensions.appBarTopPadding),
          child: Text(
            SettingsConstants.pageTitle,
            style: TextStyle(fontWeight: AppTypography.boldWeight),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.horizontalPadding,
          vertical: AppDimensions.verticalPadding,
        ),
        child: Column(
          children: [
            // Avatar Section
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadius,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.largeContainerPaddingVertical,
                  horizontal: AppDimensions.containerPaddingHorizontal,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      SettingsConstants.changeAvatarText,
                      style: TextStyle(
                        fontWeight: AppTypography.boldWeight,
                        fontSize: AppTypography.headingFontSize,
                      ),
                    ),
                    CircleAvatar(
                      radius: AppDimensions.largeAvatarRadius,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      backgroundImage: avatarImage,
                      child:
                          avatarImage == null
                              ? Icon(
                                Icons.person,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                size: AppDimensions.largeIconSize,
                              )
                              : null,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.sectionSpacing),
            // Username Section
            GestureDetector(
              onTap: () {
                setState(() {
                  _easterEggCounter++;
                  if (_easterEggCounter >= AppValues.easterEggTriggerCount) {
                    _easterEggCounter = AppValues.easterEggResetCount;
                    showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: const Text(SettingsConstants.easterEggTitle),
                            content: Image.asset(
                              SettingsConstants.easterEggImagePath,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(AppStrings.hideText),
                              ),
                            ],
                          ),
                    );
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadius,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.containerPaddingVertical,
                  horizontal: AppDimensions.containerPaddingHorizontal,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      SettingsConstants.usernameText,
                      style: TextStyle(fontWeight: AppTypography.boldWeight),
                    ),
                    SizedBox(
                      width: AppDimensions.textFieldWidth,
                      child: TextField(
                        controller: _nameController,
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: AppDimensions.textFieldVerticalPadding,
                          ),
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
            const SizedBox(height: AppDimensions.sectionSpacing),
            // Notifications Section
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.containerPaddingVertical,
                horizontal: AppDimensions.containerPaddingHorizontal,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    SettingsConstants.notificationsText,
                    style: TextStyle(fontWeight: AppTypography.boldWeight),
                  ),
                  Switch(
                    value: _notifications,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (value) {
                      setState(() => _notifications = value);
                      _updateNotifications(value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.sectionSpacing),
            // Appearance Section
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.containerPaddingVertical,
                horizontal: AppDimensions.containerPaddingHorizontal,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    SettingsConstants.appearanceText,
                    style: TextStyle(fontWeight: AppTypography.boldWeight),
                  ),
                  Consumer<ThemeManager>(
                    builder: (context, themeManager, child) {
                      return DropdownButton<ThemeOption>(
                        value: themeManager.themeOption,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(
                            value: ThemeOption.light,
                            child: Text(SettingsConstants.lightThemeText),
                          ),
                          DropdownMenuItem(
                            value: ThemeOption.dark,
                            child: Text(SettingsConstants.darkThemeText),
                          ),
                          DropdownMenuItem(
                            value: ThemeOption.system,
                            child: Text(SettingsConstants.systemThemeText),
                          ),
                        ],
                        onChanged: (ThemeOption? newValue) {
                          if (newValue != null) {
                            themeManager.setThemeOption(newValue);
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            // Add spacing before logout button
            const SizedBox(height: AppDimensions.beforeLogoutSpacing),
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text(
                            SettingsConstants.logoutConfirmTitle,
                          ),
                          content: const Text(
                            SettingsConstants.logoutConfirmMessage,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(AppStrings.cancelText),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _logout();
                              },
                              child: Text(
                                SettingsConstants.logoutText,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.buttonVerticalPadding,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadius,
                    ),
                  ),
                ),
                child: const Text(
                  SettingsConstants.logoutText,
                  style: TextStyle(fontWeight: AppTypography.boldWeight),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
