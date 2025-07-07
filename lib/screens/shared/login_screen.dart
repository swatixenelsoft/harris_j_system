import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/login_provider.dart';
import 'package:harris_j_system/screens/navigation/constant.dart';
import 'package:harris_j_system/services/api_service.dart';
import 'package:harris_j_system/ulits/common_function.dart';
import 'package:harris_j_system/ulits/toast_helper.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // ✅ Form Key for validation
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isVisible = true;

  // ✅ Email Validation
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    String trimmedEmail = value.trim();
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (!emailRegex.hasMatch(trimmedEmail)) {
      return "Enter a valid email";
    }
    return null;
  }

  // ✅ Password Validation
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    String trimmedPassword = value.trim();
    if (trimmedPassword.length < 8) {
      return "The password must be at least 8 characters.";
    }
    // final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*\W).+$');
    // if (!passwordRegex.hasMatch(trimmedPassword)) {
    //   return "The password must contain at least one lowercase letter, one uppercase letter ,least one number and a special character";
    // }
    if (trimmedPassword.length > 16) {
      return "The password must be at most 16 characters.";
    }

    return null;
  }

  // ✅ Validate and Submit Form

  void _submitForm() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final response =
          await ref.read(loginProvider.notifier).login(email, password);

      if (!mounted) return;

      final bool status = response['status'] ?? false;
      final String dashboardName = response['dashboard_name'] ?? '';
      final int roleId = response['user']?['role_id'] ?? 0;
      final int userId = response['user']?['id'] ?? 0;
      final String token = response['token'] ?? "";

      if (status) {
        await CommonFunction().storeCustomerData(
          userId: userId,
          roleId: roleId,
          token: token,
        );

        ToastHelper.showSuccess(
            context, response['message'] ?? 'Login successful');

        final prefs = await SharedPreferences.getInstance();
        final bool isLoggedIn = prefs.getBool('isLoggedIn_$userId') ?? false;

        // if (!isLoggedIn) {
        //   // First-time login for this user
        //   await prefs.setBool('isLoggedIn_$userId', true);
        //   context.push(Constant.basicInfo);
        //   return;
        // }

        // Navigate based on dashboard name and role ID
        if (dashboardName == "BOM Dashboard" && roleId == 6) {
          print('Navigating to BOM Dashboard');
          context.push(Constant.bomDashBoardScreen);
        } else if (dashboardName == "Consultant Dashboard" && roleId == 11) {
          print('Navigating to Consultant Dashboard');
          context.push(Constant.consultantDashBoardScreen);
        } else if (dashboardName == "Consultancy Dashboard" && roleId == 7) {
          print('Navigating to Consultancy Dashboard');
          context.push(Constant.consultancyDashBoardScreen);
        } else if (dashboardName == "HR Dashboard" && roleId == 8) {
          print('Navigating to HR Dashboard');
          context.push(Constant.hrDashboardScreen);
        }
        else if (dashboardName == "Operator Dashboard" && roleId == 10) {
          print('Navigating to Operator Dashboard');
          context.push(Constant.operatorDashboardScreen);
        }
        else {
          print('Dashboard routing error');
        }
      } else {
        ToastHelper.showError(context, response['message'] ?? 'Login failed');
      }
    } catch (e) {
      if (!mounted) return;
      print('Login error: $e');
      ToastHelper.showError(context, 'Something went wrong. Please try again.');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loginProvider).isLoading;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 51),
                Image.asset(
                  'assets/images/bom/bom_logo.png',
                  height: 61,
                  width: 138,
                ),
                const SizedBox(height: 100),
                // ✅ Tagline
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  child: Text(
                    "“Track Your Impact, Make Progress,\nTransform Lives”",
                    style: GoogleFonts.ubuntu(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff000000)),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 45),

                // ✅ Email Input Field
                CustomTextField(
                  label: 'Email',
                  hintText: 'Enter email',
                  controller: _emailController,
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 20),

                // ✅ Password Input Field
                CustomTextField(
                    label: 'Password',
                    hintText: 'Enter password',
                    controller: _passwordController,
                    isPassword: _isVisible,
                    validator: _validatePassword,
                    keyboardType: TextInputType.visiblePassword,
                    textCapitalization: TextCapitalization.sentences,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isVisible ? Icons.visibility_off : Icons.visibility,
                        size: 26,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isVisible = !_isVisible;
                        });
                      },
                    )),
                const SizedBox(height: 8),

                // ✅ Remember Me & Forgot Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Transform.scale(
                          scale: 18 / 24, // Scale based on default height (24)
                          child: SizedBox(
                            width: 40,
                            height: 25, // Custom height
                            child: Switch(
                              value: _rememberMe,
                              activeColor: Colors.white,
                              activeTrackColor: const Color(0xffFF1901),
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: const Color(0xFFD9D9D9),
                              trackOutlineColor:
                                  WidgetStateProperty.resolveWith((states) {
                                return states.contains(WidgetState.selected)
                                    ? const Color(0xffFF1901)
                                    : const Color(0xFFD9D9D9);
                              }),
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = !_rememberMe;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text("Remember Me",
                            style: GoogleFonts.montserrat(
                                fontSize: 12, fontWeight: FontWeight.w400)),
                      ],
                    ),
                    Text(
                      "Password Assistance",
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: const Color(0xff007AFF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ✅ Privacy Policy Text

                Text.rich(
                  TextSpan(
                    text:
                        "We truly protect your personal information registered in the system in accordance to ",
                    style: GoogleFonts.montserrat(
                        fontSize: 11, fontWeight: FontWeight.w400),
                    children: [
                      TextSpan(
                        text: "privacy laws",
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          decoration:
                              TextDecoration.underline, // Underline added
                        ),
                      ),
                      TextSpan(
                        text: " & ",
                        style: GoogleFonts.montserrat(
                            fontSize: 11, fontWeight: FontWeight.w400),
                      ),
                      TextSpan(
                        text: "our policy",
                        style: GoogleFonts.montserrat(
                            fontSize: 11,
                            decoration:
                                TextDecoration.underline, // Underline added
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 60),

                // ✅ Login Button
                CustomButton(
                  text: "GO!",
                  onPressed: () => _submitForm(),
                  loading: isLoading,
                ),
                const SizedBox(height: 80),

                // ✅ Footer Text
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore",
                  style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
