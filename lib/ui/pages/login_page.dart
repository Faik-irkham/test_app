import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/auth/auth_bloc.dart';
import 'package:test_app/models/login_form_model.dart';
import 'package:test_app/models/register_form_model.dart';
import 'package:test_app/shared/theme.dart';
import 'package:test_app/ui/widgets/button_widget.dart';
import 'package:test_app/ui/widgets/custom_snackbar.dart';
import 'package:test_app/ui/widgets/form_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final TextEditingController registerEmailController = TextEditingController();
  final TextEditingController registerPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  bool loginValidate() {
    return loginFormKey.currentState?.validate() ?? false;
  }

  bool registerValidate() {
    return registerFormKey.currentState?.validate() ?? false;
  }

  bool isObsecure = true;

  @override
  void dispose() {
    tabController.dispose();
    loginEmailController.dispose();
    loginPasswordController.dispose();
    registerEmailController.dispose();
    registerPasswordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              top: 60,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 100),
                  Text(
                    'Go ahead and setup\nyour account',
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Sign In to enjoy the app',
                    style: TextStyle(
                      color: greyColor,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.68,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: greyColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: TabBar(
                        controller: tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerHeight: 0,
                        labelPadding: const EdgeInsets.symmetric(vertical: 4),
                        labelColor: blackColor,
                        unselectedLabelColor: greyColor,
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        indicator: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        tabs: const [
                          Tab(
                            text: 'Login',
                          ),
                          Tab(
                            text: 'Register',
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          builLoginForm(context),
                          buildRegisterForm(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget builLoginForm(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailed) {
          showCustomSnackbar(context, state.e);
        }

        if (state is AuthSuccess) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      },
      builder: (context, state) {
        return Form(
          key: loginFormKey,
          child: Column(
            children: [
              const SizedBox(height: 25),
              CustomTextField(
                controller: loginEmailController,
                title: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              CustomTextField(
                controller: loginPasswordController,
                title: 'Password',
                obscureText: isObsecure,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isObsecure = !isObsecure;
                    });
                  },
                  icon: isObsecure
                      ? const Icon(
                          Icons.visibility_off,
                        )
                      : const Icon(Icons.visibility),
                ),
              ),
              const SizedBox(height: 35),
              if (state is AuthLoading)
                const CircularProgressIndicator(
                  color: primaryColor,
                )
              else
                CustomFilledButton(
                  width: double.infinity,
                  title: 'Login',
                  onPressed: () {
                    if (loginValidate()) {
                      context.read<AuthBloc>().add(
                            AuthLogin(
                              LoginFormModel(
                                email: loginEmailController.text,
                                password: loginPasswordController.text,
                              ),
                            ),
                          );
                    } else {
                      showCustomSnackbar(context, 'Please fill the form');
                    }
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget buildRegisterForm() {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailed) {
          showCustomSnackbar(context, state.e);
        }

        if (state is AuthSuccess) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      },
      builder: (context, state) {
        return Form(
          key: registerFormKey,
          child: Column(
            children: [
              const SizedBox(height: 25),
              CustomTextField(
                controller: nameController,
                title: 'Name',
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              CustomTextField(
                controller: registerEmailController,
                title: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              CustomTextField(
                controller: registerPasswordController,
                title: 'Password',
                obscureText: isObsecure,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isObsecure = !isObsecure;
                    });
                  },
                  icon: isObsecure
                      ? const Icon(
                          Icons.visibility_off,
                        )
                      : const Icon(Icons.visibility),
                ),
              ),
              const SizedBox(height: 35),
              if (state is AuthLoading)
                const CircularProgressIndicator(
                  color: primaryColor,
                )
              else
                CustomFilledButton(
                  width: double.infinity,
                  title: 'Register',
                  onPressed: () {
                    if (registerValidate()) {
                      context.read<AuthBloc>().add(
                            AuthRegister(
                              RegisterFormModel(
                                name: nameController.text,
                                email: registerEmailController.text,
                                password: registerPasswordController.text,
                              ),
                            ),
                          );
                    } else {
                      showCustomSnackbar(context, 'Please fill the form');
                    }
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
