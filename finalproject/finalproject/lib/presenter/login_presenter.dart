import '../model/auth_model.dart';

abstract class LoginView {
  void showSuccess(String message);
  void showError(String message);
}

class LoginPresenter {
  final AuthModel _authModel;
  final LoginView _view;

  LoginPresenter(this._view) : _authModel = AuthModel();

  Future<bool> login(String email, String password) async {
    try {
      bool success = await _authModel.login(email, password);
      if (success) {
        _view.showSuccess("Login successful");
        return true;
      } else {
        _view.showError("Invalid email or password");
        return false;
      }
    } catch (e) {
      _view.showError(e.toString());
      return false;
    }
  }

  Future<void> createAccount(
    String email,
    String username,
    String password,
  ) async {
    try {
      await _authModel.createAccount(email, password, username);
      _view.showSuccess("Account created successfully");
    } catch (e) {
      _view.showError(e.toString());
    }
  }
}
