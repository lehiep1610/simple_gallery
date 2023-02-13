import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_gallery/modules/log_in/controller/log_in_controller.dart';
import 'package:simple_gallery/modules/log_in/screen/log_in_screen.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  @override
  Widget build(BuildContext context) {
    final loginController =
        Provider.of<LoginController>(context, listen: false);
    return Center(
      child: context.watch<LoginController>().user != null
          ? Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Profile',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 8),
                CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      NetworkImage(loginController.user!.photoUrl!),
                ),
                const SizedBox(height: 8),
                Text(
                  'Name: ${loginController.user!.displayName}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Email: ${loginController.user!.email}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    await loginController.googleLogout();
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const LogInScreen()),
                          (Route<dynamic> route) => false);
                    }
                  },
                  child: const Text(
                    'Log out',
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'You are logged in as a guest',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const LogInScreen()),
                          (Route<dynamic> route) => false);
                    }
                  },
                  child: const Text(
                    'Go to Login',
                  ),
                ),
              ],
            ),
    );
  }
}
