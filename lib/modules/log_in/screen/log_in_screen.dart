import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_gallery/constant/icon_constant.dart';
import 'package:simple_gallery/modules/gallery/controller/gallery_controller.dart';
import 'package:simple_gallery/modules/log_in/controller/log_in_controller.dart';

import '../../gallery/screen/gallery_screen.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const Icon(
                  Icons.android,
                  size: 100,
                ),
                const Text(
                  'Welcome Back!',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Sign in to your account to continue',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () {
                    Provider.of<GalleryController>(context, listen: false)
                        .reset();
                    Navigator.of(context)
                        .pushReplacementNamed(GalleryScreen.routeName);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: const Center(
                      child: Text(
                        'Sign in as GUEST',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(children: const [
                    Expanded(
                        child: Divider(
                      endIndent: 10,
                      color: Colors.grey,
                    )),
                    Text(
                      "or",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.grey),
                    ),
                    Expanded(
                        child: Divider(
                      indent: 10,
                      color: Colors.grey,
                    )),
                  ]),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    final loginController =
                        Provider.of<LoginController>(context, listen: false);
                    await loginController.googleLogIn();
                    if (context.mounted) {
                      if (loginController.user != null) {
                        Provider.of<GalleryController>(context, listen: false)
                            .reset();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: ((context) => const GalleryScreen())));
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 26,
                            height: 26,
                            child: Image.asset(IconConstants.ic_logo_google,
                                fit: BoxFit.contain)),
                        const SizedBox(width: 10),
                        const Text(
                          'Sign in with Google',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                    children: [
                      TextSpan(text: 'Do not have account? '),
                      TextSpan(
                          text: 'Sign up',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
