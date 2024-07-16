import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:test_app/blocs/auth/auth_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    const delayDuration = Duration(seconds: 5);

    void navigateAfterDelay(AuthState state) {
      Future.delayed(delayDuration, () {
        if (state is AuthSuccess) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        } else if (state is AuthFailed) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);
        }
      });
    }

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          navigateAfterDelay(state);
        },
        child: Center(
          child: Lottie.asset(
            'assets/animation/splash.json',
          ),
        ),
      ),
    );
  }
}
