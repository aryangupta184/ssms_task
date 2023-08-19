enum APP_PAGE {
  signin,
  signup,
  login,
  home,
  phone,
  customer,
  signincust,
  signupcust
}

extension AppPageExtension on APP_PAGE {
  String get toPath {
    switch (this) {
      case APP_PAGE.home:
        return "/";
      case APP_PAGE.login:
        return "/login";
      case APP_PAGE.signin:
        return "/signin";
      case APP_PAGE.signup:
        return "/signup";
      case APP_PAGE.phone:
        return "/phone";
      case APP_PAGE.customer:
        return "/customer";
      case APP_PAGE.signincust:
        return "/signincustomer";
      case APP_PAGE.signupcust:
        return "/signupcustomer";

      default:
        return "/";
    }
  }

  String get toName {
    switch (this) {
      case APP_PAGE.home:
        return "HOME";
      case APP_PAGE.login:
        return "LOGIN";
      case APP_PAGE.signin:
        return "SIGNIN";
      case APP_PAGE.signup:
        return "SIGNUP";
      case APP_PAGE.phone:
        return "PHONE";
      case APP_PAGE.customer:
        return "CUSTOMER";
      case APP_PAGE.signincust:
        return "SIGN IN CUSTOMER";
      case APP_PAGE.signupcust:
        return "SIGN UP CUSTOMER";


      default:
        return "HOME";
    }
  }


}