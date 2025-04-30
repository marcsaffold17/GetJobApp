import 'package:flutter/material.dart';
import '../presenter/login_presenter.dart';
import '../main.dart';

class LoginButtonPage extends StatelessWidget {
  const LoginButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage("assets/images/UMDGYM.jpg"),
              //   fit: BoxFit.cover,
              // ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(160, 20, 50, 31),
            ),
          ),
          Positioned.fill(
            child: Column(
              children: [
                SizedBox(height: 120),
                // Image.asset(
                //   'assets/images/BeastMode.png',
                //   height: 300,
                //   width: 400,
                // ),
                SizedBox(height: 40),
                const Divider(
                  height: 20,
                  thickness: 7,
                  indent: 30,
                  endIndent: 30,
                  color: Color.fromARGB(255, 244, 238, 227),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => const MyCreateAccountPage(
                              title: 'Create Account Page',
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 244, 238, 227),
                    minimumSize: const Size(250, 50),
                  ),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      color: Color.fromARGB(255, 20, 50, 31),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'RubikL',
                      fontSize: 25,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => const MyLoginPage(title: 'Login Page'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 244, 238, 227),
                    minimumSize: const Size(250, 50),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Color.fromARGB(255, 20, 50, 31),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'RubikL',
                      fontSize: 25,
                    ),
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
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
        backgroundColor: const Color.fromARGB(255, 229, 221, 212),
        content: Text(
          message,
          style: const TextStyle(color: Color.fromARGB(255, 81, 163, 108)),
        ),
      ),
    );
  }

  @override
  void showError(String message) {
    setState(() {
      _loginError = message; // Store the error message
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
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              SizedBox(height: 100),
              Container(
                height: 200,
                width: 200,
                // decoration: const BoxDecoration(
                // ),
              ),
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
                                TextSpan(text: '\n  Sign In'),
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
                                      width: 250,
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
                                            fontFamily: 'RubikL',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 16.0,
                                  ), // Add space from the right
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
                                      onPressed: () async {
                                        bool isValid =
                                            await presenter.CheckAccountInfo(
                                              emailText.text,
                                              passWordText.text,
                                            );
                                        if (isValid) {
                                          // globalUsername = userNameText.text;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => MyHomePage(
                                                    title: 'Home Page',
                                                    // username: userNameText.text,
                                                  ),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(
                                          fontFamily: 'RubikL',
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
                                SizedBox(height: 140),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Don't have an account?"),
                                    // Container(
                                    //   width: 400,
                                    //   height: 60,
                                    //   decoration: BoxDecoration(
                                    //     color: Colors.transparent,
                                    //     // borderRadius: BorderRadius.circular(30.0),
                                    //   ),
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
                                          color: Color.fromARGB(255, 0, 43, 75),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'RubikL',
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

  @override
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.red)),
      ),
    );
  }

  void handleCreateAccount() {
    if (passWordText.text != confirmPassWordText.text) {
      setState(() {
        _passwordError = "Passwords do not match";
      });
    } else {
      setState(() {
        _passwordError = null;
      });
      presenter.createAccount(
        emailText.text,
        userNameText.text,
        passWordText.text,
      );
    }
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
                                fontFamily: 'MontserratB',
                                fontSize: 40,
                                color: const Color.fromARGB(255, 0, 43, 75),
                              ),
                              children: const <TextSpan>[
                                TextSpan(text: '  Create\n  Account'),
                              ],
                            ),
                          ),
                        ),
                        // SizedBox(height: 0),
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
                                            fontFamily: 'RubikL',
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
                                          fontFamily: 'RubikL',
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
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Already have an account?"),

                                    // Container(
                                    //   width: 400,
                                    //   height: 60,
                                    //   decoration: BoxDecoration(
                                    //     color: Colors.transparent,
                                    //     // borderRadius: BorderRadius.circular(30.0),
                                    //   ),
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
                                          color: Color.fromARGB(255, 0, 43, 75),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'RubikL',
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          //container
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
          color: Color.fromARGB(255, 244, 238, 227),
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
        style: const TextStyle(
          fontFamily: 'RubikL',
          fontWeight: FontWeight.bold,
        ),
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
