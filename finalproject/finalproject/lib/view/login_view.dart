import 'package:flutter/material.dart';
import '../presenter/login_presenter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'homepage_view.dart';
import 'navBar_view.dart';

class ResetPasswordPage extends StatelessWidget {
  ResetPasswordPage({super.key});
  final emailText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: const Color.fromARGB(255, 244, 243, 240),
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      // ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 244, 243, 240),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Reset Password',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 43, 75),
                    ),
                  ),
                  const SizedBox(height: 30),
                  LoginTextField(
                    userNameText: emailText,
                    hintText: 'Email',
                    obscure: false,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: emailText.text.trim(),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password reset email sent'),
                          ),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 43, 75),
                      minimumSize: const Size(250, 50),
                    ),
                    child: const Text(
                      'Send Reset Link',
                      style: TextStyle(
                        color: Color.fromARGB(255, 244, 243, 240),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'JetB',
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          backButton(context),
        ],
      ),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key, required this.title});
  final String title;

  @override
  LoginPage createState() => LoginPage();
}

class LoginPage extends State<MyLoginPage> implements LoginView {
  late LoginPresenter presenter;
  final userNameText = TextEditingController();
  final passWordText = TextEditingController();
  final emailText = TextEditingController();
  String? _loginError;

  @override
  void initState() {
    super.initState();
    presenter = LoginPresenter(this);
  }

  @override
  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color.fromARGB(255, 244, 243, 240),
        content: Text(
          message,
          style: const TextStyle(color: Color.fromARGB(255, 17, 84, 116)),
        ),
      ),
    );
  }

  @override
  void showError(String message) {
    setState(() {
      _loginError = message;
    });
  }

  void _clearError() {
    if (_loginError != null) {
      setState(() {
        _loginError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 243, 240),
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              SizedBox(height: 100),
              Container(height: 200, width: 200),
              Container(
                height: constraints.maxHeight,
                color: const Color.fromARGB(255, 244, 243, 240),
              ),
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 20, 50, 31),
                          ),
                        ),
                        SizedBox(height: 100),
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: Image(
                            image: AssetImage("assets/images/Logo.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: 'MontserratB',
                                fontSize: 40,
                                color: const Color.fromARGB(255, 0, 43, 75),
                              ),
                              children: const <TextSpan>[
                                TextSpan(
                                  text: '\n  Sign In',
                                  style: TextStyle(fontFamily: 'inter'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Positioned(
                          left: -5,
                          right: -5,
                          top: 200,
                          bottom: -15,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(height: 20),
                                LoginTextField(
                                  userNameText: emailText,
                                  hintText: 'Email',
                                  obscure: false,
                                  onChanged: (_) => _clearError(),
                                ),
                                SizedBox(height: 12),
                                LoginTextField(
                                  userNameText: passWordText,
                                  hintText: 'Password',
                                  obscure: true,
                                  onChanged: (_) => _clearError(),
                                ),
                                if (_loginError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      right: 60,
                                    ),
                                    child: Container(
                                      width: 270,
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 202, 59, 59),
                                        borderRadius: BorderRadius.circular(
                                          30.0,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                          bottom: 8.0,
                                        ),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          _loginError!,
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                              255,
                                              229,
                                              221,
                                              212,
                                            ),
                                            fontFamily: 'JetB',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                // SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.only(right: 30),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 0,
                                        horizontal: 0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          30.0,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => ResetPasswordPage(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 0, 43, 75),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'JetB',
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: SizedBox(
                                    width: 200,
                                    height: 60,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                          255,
                                          0,
                                          43,
                                          75,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30.0,
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        FocusScope.of(context).unfocus();
                                        if (emailText.text.isEmpty ||
                                            passWordText.text.isEmpty) {
                                          showError(
                                            "Please enter both email and password",
                                          );
                                          return;
                                        }
                                        bool success =
                                            await showDialog<bool>(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) {
                                                return FutureBuilder<bool>(
                                                  future: presenter.login(
                                                    emailText.text.trim(),
                                                    passWordText.text,
                                                  ),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    }
                                                    Navigator.of(context).pop(
                                                      snapshot.data ?? false,
                                                    );
                                                    return Container();
                                                  },
                                                );
                                              },
                                            ) ??
                                            false;

                                        if (success && mounted) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      NavigationMenuView(),
                                              // (context) => MyHomePage(
                                              //   title: 'Home Page',
                                              // ),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(
                                          fontFamily: 'JetB',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                            255,
                                            244,
                                            238,
                                            227,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 100),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 10),
                                    Text(
                                      "Don't have an account?",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 17, 84, 116),
                                        fontFamily: 'JetB',
                                        fontSize: 14,
                                      ),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12.0,
                                          horizontal: 16.0,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30.0,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    const MyCreateAccountPage(
                                                      title:
                                                          'Create Account Page',
                                                    ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Create Account',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color.fromARGB(255, 0, 43, 75),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'JetB',
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MyCreateAccountPage extends StatefulWidget {
  const MyCreateAccountPage({super.key, required this.title});
  final String title;

  @override
  CreateAccountPage createState() => CreateAccountPage();
}

class CreateAccountPage extends State<MyCreateAccountPage>
    implements LoginView {
  late LoginPresenter presenter;
  final userNameText = TextEditingController();
  final passWordText = TextEditingController();
  final emailText = TextEditingController();
  final confirmPassWordText = TextEditingController();

  String? _passwordError;
  String? _emailError;

  @override
  void initState() {
    super.initState();
    presenter = LoginPresenter(this);
  }

  @override
  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.green)),
      ),
    );
  }

  void showError(String message) {
    setState(() {
      _emailError = message;
    });
  }

  void _clearError() {
    if (_emailError != null) {
      setState(() {
        _emailError = null;
      });
    }
  }

  void handleCreateAccount() {
    if (!EmailValidator.validate(emailText.text.trim())) {
      showError("Please enter a valid email address");
      return;
    }
    if (passWordText.text != confirmPassWordText.text) {
      setState(() {
        _passwordError = "Passwords do not match";
      });
      return;
    }
    if (passWordText.text.length < 6) {
      setState(() {
        _passwordError = "Password must be at least 6 characters";
      });
      return;
    }

    setState(() {
      _passwordError = null;
    });

    presenter.createAccount(
      emailText.text.trim(),
      userNameText.text.trim(),
      passWordText.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              SizedBox(height: 100),
              Container(
                height: constraints.maxHeight,
                color: const Color.fromARGB(255, 244, 243, 240),
              ),
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        SizedBox(height: 100),
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: Image(
                            image: AssetImage("assets/images/Logo.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: 'inter',
                                fontSize: 40,
                                color: const Color.fromARGB(255, 0, 43, 75),
                              ),
                              children: const <TextSpan>[
                                TextSpan(text: '  Create\n  Account'),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: -5,
                          right: -5,
                          top: 200,
                          bottom: -15,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(height: 30),
                                LoginTextField(
                                  userNameText: userNameText,
                                  hintText: 'Username',
                                  obscure: false,
                                ),
                                SizedBox(height: 12),
                                LoginTextField(
                                  userNameText: emailText,
                                  hintText: 'Email',
                                  obscure: false,
                                  onChanged: (_) => _clearError(),
                                ),
                                SizedBox(height: 12),
                                LoginTextField(
                                  userNameText: passWordText,
                                  hintText: 'Password',
                                  obscure: true,
                                  onChanged: (value) {
                                    if (_passwordError != null) {
                                      setState(() {
                                        _passwordError = null;
                                      });
                                    }
                                  },
                                ),
                                SizedBox(height: 12),
                                LoginTextField(
                                  userNameText: confirmPassWordText,
                                  hintText: 'Confirm Password',
                                  obscure: true,
                                  onChanged: (value) {
                                    if (_passwordError != null) {
                                      setState(() {
                                        _passwordError = null;
                                      });
                                    }
                                  },
                                ),
                                if (_emailError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      right: 60,
                                    ),
                                    child: Container(
                                      width: 270,
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 202, 59, 59),
                                        borderRadius: BorderRadius.circular(
                                          30.0,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                          bottom: 8.0,
                                        ),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          _emailError!,
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                              255,
                                              229,
                                              221,
                                              212,
                                            ),
                                            fontFamily: 'JetB',
                                            // fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (_passwordError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      right: 80,
                                    ),
                                    child: Container(
                                      width: 200,
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 202, 59, 59),
                                        borderRadius: BorderRadius.circular(
                                          30.0,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                          bottom: 8.0,
                                        ),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          _passwordError!,
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                              255,
                                              229,
                                              221,
                                              212,
                                            ),
                                            fontSize: 14,
                                            fontFamily: 'JetB',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Container(
                                    width: 200,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 0, 43, 75),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12.0,
                                          horizontal: 16.0,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30.0,
                                          ),
                                        ),
                                      ),
                                      onPressed: handleCreateAccount,
                                      child: const Text(
                                        'Create Account',
                                        style: TextStyle(
                                          fontFamily: 'JetB',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                          // fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                            255,
                                            244,
                                            238,
                                            227,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already have an account?",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 17, 84, 116),
                                        fontFamily: 'JetB',
                                      ),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12.0,
                                          horizontal: 16.0,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30.0,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => const MyLoginPage(
                                                  title: 'Create Account Page',
                                                ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color.fromARGB(255, 0, 43, 75),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'JetB',
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              backButton(context),
            ],
          );
        },
      ),
    );
  }
}

// Credit: Eva Elvarsdottir from BIG sleeperzzz
Widget backButton(BuildContext context) {
  return Stack(
    children: [
      Positioned(
        top: 35,
        left: 10,
        child: IconButton(
          icon: Icon(Icons.arrow_back),
          iconSize: 35,
          color: Color.fromARGB(255, 0, 43, 75),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    ],
  );
}

class LoginTextField extends StatelessWidget {
  const LoginTextField({
    super.key,
    required this.userNameText,
    required this.hintText,
    required this.obscure,
    this.onChanged,
  });

  final TextEditingController userNameText;
  final String hintText;
  final bool obscure;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextField(
        style: const TextStyle(fontFamily: 'JetB', fontWeight: FontWeight.bold),
        controller: userNameText,
        obscureText: obscure,
        onChanged: onChanged,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 0, 43, 75),
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              width: 3.0,
              color: Color.fromARGB(255, 34, 124, 157),
            ),
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}
