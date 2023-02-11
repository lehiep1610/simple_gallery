import 'package:flutter/material.dart';
import 'package:simple_gallery/constant/icon_constant.dart';

import '../../gallery/screen/gallery_screen.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black45),
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.0)),
                  child: const TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Email'),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black45),
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.0)),
                  child: const TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: ((context) => const GalleryScreen())));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: const Center(
                      child: Text(
                        'Sign in',
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
                      color: Colors.black87,
                    )),
                    Text(
                      "or",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.black54),
                    ),
                    Expanded(
                        child: Divider(
                      indent: 10,
                      color: Colors.black87,
                    )),
                  ]),
                ),
                const SizedBox(height: 10),
                Container(
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
                const Spacer(),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 15),
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
