import 'package:flutter/material.dart'; 
import '../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String _errorMessage = '';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Join iLiftFork',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8.0),

            Text(
              'Create an account to track your journey',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 32.0),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 16.0),

            TextField(
              controller: passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility: Icons.visibility_off,
                  ),

                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  }
                )
              ),
            ),

            const SizedBox(height: 16.0),

            TextField(
              controller: confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              )
            ),

            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            
            const SizedBox(height: 24.0),

            _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),

                  child: const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 16.0),
                  )
              ),
          
          const SizedBox(height: 24.0),

          Row(
            children: [
              const Expanded(child: Divider()), 
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'OR SIGN UP WITH',
                  style: TextStyle(
                    fontSize: 12.0, 
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),

          const SizedBox(height: 24.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(
                onPressed: _signUpWithGoogle,
                icon: 'G',
                color: Colors.red[400]!,
                tooltip: 'Sign up with Google',
              ),

              const SizedBox(width: 16.0),

              _buildSocialButton(
                onPressed: _signUpWithFacebook,
                icon: 'F',
                color: Colors.blue[800]!,
                tooltip: 'Sign up with Facebook',
              ),

              const SizedBox(width: 16.0),

              _buildSocialButton(
                onPressed: _signUpWithApple,
                icon: '🍎',
                color: Colors.black,
                tooltip: 'Sign up with Apple',
              ),
            ]
          )
          ]
        )
      )
    );
  }

  void _signUp() async {
    setState(() {
      _errorMessage = '';
    });

    if (emailController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your email';
      });
      
      return; 
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text.trim())) {
      setState(() {
        _errorMessage = 'Please enter a valid email address';
      });
      
      return;
    }

    if (passwordController.text.length < 6) {
      setState(() {
        _errorMessage = 'Password must be at least 6 characters';
      });

      return; 
    }

    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });

      return; 
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.signUp(
        emailController.text.trim(),
        passwordController.text.trim(), 
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully!')),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      String message = 'An error occurred';

      if (e.toString().contains('email-already-in-use')) {
        message = 'This email is already registered. Please try logging in.';
      } else if (e.toString().contains('invalid-email')) {
        message = 'Please enter a valid email address.';
      } else if (e.toString().contains('weak-password')) {
        message = 'Your password is too weak.';
      }

      if (mounted){
        setState(() {
          _errorMessage = message;
        });
      }
    } finally {
      if (mounted) {
        setState( () {
          _isLoading = false;
        });
      }
    }
    // Future.delayed(const Duration(seconds: 1), () {
    //   if (mounted) {
    //     setState(() {
    //       _isLoading = false;
    //     });

    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Sign up fnctionality coming soon!')),
    //     );
    //   } 
    // });
  }

  Widget _buildSocialButton({
    required VoidCallback onPressed,
    required String icon,
    required Color color,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Center(
            child: icon.startsWith('🍎')
                ? Text(icon, style: const TextStyle(fontSize: 24))
                : Text(
                    icon, 
                    style: TextStyle(
                      color: color,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                ),
          ),
        ),
      ),
    );
  }

  void _signUpWithGoogle() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google sign up coming soon!')),
    );
  }

  void _signUpWithFacebook() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Facebook sign up coming soon!')),
    );
  }
  void _signUpWithApple() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Apple sign up coming soon!')),
    );
  }
}
