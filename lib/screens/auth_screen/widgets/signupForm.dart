import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/controller/auth_controller.dart';
import 'package:task_manager_app/screens/auth_gateway/auth_gateway.dart';
import 'package:task_manager_app/screens/auth_screen/widgets/passwordField.dart';

class SignUpForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final OutlineInputBorder inputBorder;
  final Color fillColor;
  final Color btnColor;
  final double scale;

  SignUpForm({
    super.key,
    required this.formKey,
    required this.inputBorder,
    required this.fillColor,
    required this.btnColor,
    required this.scale,
  });

  AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create your account',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16 * s,
              ),
            ),
            SizedBox(height: 6 * s),
            Text(
              'Start planning your perfect\nwedding',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFF6B6B6B),
                height: 1.3,
                fontSize: 13 * s,
              ),
            ),
            SizedBox(height: 16 * s),

            Text(
              'Full Name',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontSize: 14 * s),
            ),
            SizedBox(height: 6 * s),
            TextFormField(
              controller: authController.signName,
              decoration: InputDecoration(
                hintText: 'Sarah Johnson',
                filled: true,
                fillColor: fillColor,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14 * s,
                  vertical: 12 * s,
                ),
                border: inputBorder,
                enabledBorder: inputBorder,
                focusedBorder: inputBorder.copyWith(
                  borderSide: BorderSide(
                    color: Colors.black12.withOpacity(0.25),
                  ),
                ),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Name required' : null,
            ),
            SizedBox(height: 12 * s),

            Text(
              'Email',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontSize: 14 * s),
            ),
            SizedBox(height: 6 * s),
            TextFormField(
              controller: authController.signEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'your@email.com',
                filled: true,
                fillColor: fillColor,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14 * s,
                  vertical: 12 * s,
                ),
                border: inputBorder,
                enabledBorder: inputBorder,
                focusedBorder: inputBorder.copyWith(
                  borderSide: BorderSide(
                    color: Colors.black12.withOpacity(0.25),
                  ),
                ),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email required';
                final ok = RegExp(
                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                ).hasMatch(v.trim());
                return ok ? null : 'Invalid email';
              },
            ),
            SizedBox(height: 12 * s),

            Text(
              'Password',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontSize: 14 * s),
            ),
            SizedBox(height: 6 * s),
            PasswordField(
              controller: authController.signPassword,
              hint: '••••••••',
              inputBorder: inputBorder,
              fillColor: fillColor,
              s: s,
            ),
            SizedBox(height: 12 * s),

            Text(
              'Confirm Password',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontSize: 14 * s),
            ),
            SizedBox(height: 6 * s),
            PasswordField(
              controller: authController.signConfirm,
              hint: '••••••••',
              inputBorder: inputBorder,
              fillColor: fillColor,
              s: s,
            ),
            SizedBox(height: 16 * s),

            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: btnColor,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 14 * s),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14 * s),
                    ),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    // Left empty; will connect to Firebase later
                    await authController.createUser();
                    Get.offAll(AuthGateway());
                  },
                  child: authController.isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 16 * s,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 10 * s),
          ],
        ),
      ),
    );
  }
}
