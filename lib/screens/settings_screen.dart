import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool locationNotificationsEnabled = true;
  final AuthService _authService = AuthService();
  Map<String, dynamic>? userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final profile = await _authService.getUserProfile(user.uid);
      setState(() {
        userProfile = profile;
        notificationsEnabled = profile?['notificationsEnabled'] ?? true;
        locationNotificationsEnabled =
            profile?['locationNotificationsEnabled'] ?? true;
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    try {
      await _authService.logout();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Logout failed: $e')));
      }
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // User Profile Header
                  Container(
                    color: const Color(0xFF0D1B2A),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: Text(
                            (user?.email ?? 'U')[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D1B2A),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user?.email ?? 'Unknown',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userProfile?['displayName'] ?? 'User',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
<<<<<<< HEAD
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _authService.isEmailVerified()
                                ? Colors.green
                                : Colors.orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _authService.isEmailVerified()
                                ? "✓ Email Verified"
                                : "⚠ Email Not Verified",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Account Settings Section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Text(
                            "Account Settings",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Card(
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.person),
                                title: const Text("Profile Information"),
                                subtitle: const Text(
                                  "View and edit your profile",
                                ),
                                trailing: const Icon(Icons.arrow_forward),
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Profile management coming soon",
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const Divider(height: 0),
                              ListTile(
                                leading: const Icon(Icons.lock),
                                title: const Text("Change Password"),
                                subtitle: const Text("Update your password"),
                                trailing: const Icon(Icons.arrow_forward),
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Password reset coming soon",
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
=======
>>>>>>> e18d788 (addition of files)
                      ],
                    ),
                  ),

                  // Notifications Section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Text(
                            "Notifications",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Card(
                          child: Column(
                            children: [
                              SwitchListTile(
                                secondary: const Icon(Icons.notifications),
                                title: const Text("Push Notifications"),
                                subtitle: const Text(
                                  "Receive app notifications",
                                ),
                                value: notificationsEnabled,
                                onChanged: (value) async {
                                  setState(() => notificationsEnabled = value);
                                  await _authService
                                      .updateNotificationPreference(
<<<<<<< HEAD
                                        FirebaseAuth.instance.currentUser!.uid,
                                        value,
                                      );
=======
                                    FirebaseAuth.instance.currentUser!.uid,
                                    value,
                                  );
>>>>>>> e18d788 (addition of files)
                                },
                              ),
                              const Divider(height: 0),
                              SwitchListTile(
                                secondary: const Icon(Icons.location_on),
                                title: const Text("Location Notifications"),
                                subtitle: const Text(
                                  "Get alerts for nearby services",
                                ),
                                value: locationNotificationsEnabled,
                                onChanged: (value) {
                                  setState(
                                    () => locationNotificationsEnabled = value,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // About Section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Text(
                            "About",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Card(
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.info),
                                title: const Text("About App"),
                                subtitle: const Text(
                                  "v1.0.0 - Kigali City Directory",
                                ),
                                trailing: const Icon(Icons.arrow_forward),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("About"),
                                      content: const Text(
                                        "Kigali City Directory v1.0.0\n\n"
                                        "Help Kigali residents discover and navigate to essential public services and leisure locations including hospitals, police stations, libraries, restaurants, and tourist attractions.",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Close"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const Divider(height: 0),
                              ListTile(
                                leading: const Icon(Icons.privacy_tip),
                                title: const Text("Privacy Policy"),
                                subtitle: const Text("View privacy policy"),
                                trailing: const Icon(Icons.arrow_forward),
                                onTap: () {
<<<<<<< HEAD
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Privacy policy available online",
                                      ),
=======
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Privacy Policy"),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Text(
                                              "Privacy Policy - Kigali City Directory",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(height: 12),
                                            Text(
                                              "Last Updated: March 2026",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              "1. Information We Collect",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "• Email address and authentication information\n"
                                              "• Listings you create (name, category, location, contact info)\n"
                                              "• Bookmarked places\n"
                                              "• App usage information",
                                            ),
                                            SizedBox(height: 12),
                                            Text(
                                              "2. How We Use Your Information",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "• To provide and improve our services\n"
                                              "• To display your listings and bookmarks\n"
                                              "• To authenticate your account\n"
                                              "• To send service-related notifications",
                                            ),
                                            SizedBox(height: 12),
                                            Text(
                                              "3. Data Protection",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Your data is stored securely using Firebase. We implement industry-standard security measures to protect your information.",
                                            ),
                                            SizedBox(height: 12),
                                            Text(
                                              "4. Your Rights",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "• You can view, edit, or delete your account\n"
                                              "• You can manage your listings and bookmarks\n"
                                              "• You can request deletion of your data",
                                            ),
                                            SizedBox(height: 12),
                                            Text(
                                              "5. Contact Us",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "If you have privacy concerns, please contact us at: privacy@kigalicitydirectory.rw",
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("I Agree"),
                                        ),
                                      ],
>>>>>>> e18d788 (addition of files)
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Logout Button
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _showLogoutDialog,
                        icon: const Icon(Icons.logout),
                        label: const Text("Logout"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
