import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/auth/auth_bloc.dart';
import 'package:test_app/ui/widgets/button_widget.dart';
import 'package:test_app/ui/widgets/custom_snackbar.dart';
import 'package:test_app/ui/widgets/profile_item.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailed) {
            showCustomSnackbar(context, state.e);
          }

          if (state is AuthInitial) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is AuthSuccess) {
              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  ProfileItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Name',
                    value: state.user.name ?? 'No Name',
                  ),
                  ProfileItem(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    value: state.user.email ?? 'No Email',
                  ),
                  CustomFilledButton(
                    title: 'Logout',
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLogout());
                    },
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
