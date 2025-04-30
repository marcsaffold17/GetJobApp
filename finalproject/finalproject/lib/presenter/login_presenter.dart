import '../model/auth_model.dart';

abstract class LoginView {
  void showSuccess(String message);
  void showError(String message);
}

class LoginPresenter {
  final AuthModel _authModel;
  final LoginView _view;

  LoginPresenter(this._view) : _authModel = AuthModel();

  void createAccount(String email, String username, String password) {
    _authModel
        .createAccount(email, username, password)
        .then((_) {
          _view.showSuccess("Account created successfully");
        })
        .catchError((error) {
          _view.showError("Couldn't create account");
        });
  }

  Future<bool> CheckAccountInfo(String email, String password) async {
    try {
      bool isValid = await _authModel.CheckAccountInfo(email, password);
      if (isValid) {
        _view.showSuccess("Correct Password");
        return true;
      } else {
        _view.showError("Invalid Username/Password");
        return false;
      }
    } catch (error) {
      _view.showError("Error checking account");
      return false; // Ensure a return value even if an error occurs
    }
  }
}
