import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 342,
                height: 160.8,
                child: Image(
                  image: AssetImage(
                    "assets/icons/Logo_Name.png",
                  ),
                ),
              ),
              const SizedBox(height: 120),
              authProvider.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        authProvider.login();
                      },
                      child: const Text('로그인'),
                    ),
              if (authProvider.accessToken != null)
                Text('Token: ${authProvider.accessToken}'),
            ],
          ),
        ),
      ),
    );
  }
}
