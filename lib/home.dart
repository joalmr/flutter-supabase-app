import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _userId;

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();

    supabase.auth.onAuthStateChange.listen((data) {
      if (data.session != null) {
        log(
          data.session!.user.toJson().toString(),
          name: 'oAuth',
        );
      }

      setState(() {
        _userId = data.session?.user.userMetadata?['full_name'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(_userId ?? 'Not signed in'),
            ElevatedButton(
              onPressed: () async => await signInWithGoogle(),
              child: const Text('Sign in with Google'),
            ),
            ElevatedButton(
              onPressed: () async => signOut(),
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    try {
      /// Web Client ID that you registered with Google Cloud.
      final webClientId = dotenv.env['WEB_CLIENT']!;

      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: webClientId,
        scopes: ['email', 'profile'],
      );

      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }

      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  Future<dynamic> signOut() async {
    await GoogleSignIn().signOut();
    await supabase.auth.signOut();
  }
}
