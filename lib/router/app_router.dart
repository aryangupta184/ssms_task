
import 'package:ssms_revamp/router/route_utils.dart';
import 'package:ssms_revamp/views/customer_page.dart';
import 'package:ssms_revamp/views/home_page.dart';
import 'package:ssms_revamp/views/login_page.dart';
import 'package:ssms_revamp/views/signin_customer.dart';
import 'package:ssms_revamp/views/signin_page.dart';
import 'package:ssms_revamp/views/signup_cust.dart';
import 'package:ssms_revamp/views/signup_page.dart';



import 'package:go_router/go_router.dart';

class AppRouter {

    GoRouter router = GoRouter(
    initialLocation: APP_PAGE.home.toPath,
    routes: <GoRoute>[
      GoRoute(
        path: APP_PAGE.home.toPath,
        name: APP_PAGE.home.toName,
        builder: (context, state) => LogInPage(),
      ),
      GoRoute(
        path: APP_PAGE.customer.toPath,
        name: APP_PAGE.customer.toName,
        builder: (context, state) => CustomerPage(),
      ),
      GoRoute(
        path: APP_PAGE.signincust.toPath,
        name: APP_PAGE.signincust.toName,
        builder: (context, state) => SignInCustPage(),
      ),


      GoRoute(
        path: APP_PAGE.signin.toPath,
        name: APP_PAGE.signin.toName,
        builder: (context, state) => SignInPage(),
      ),
      GoRoute(
        path: APP_PAGE.signup.toPath,
        name: APP_PAGE.signup.toName,
        builder: (context, state) => SignUpPage(),
      ),
      GoRoute(
        path: APP_PAGE.signupcust.toPath,
        name: APP_PAGE.signupcust.toName,
        builder: (context, state) => SignUpCustPage(),
      ),
      GoRoute(
        path: APP_PAGE.login.toPath,
        name: APP_PAGE.login.toName,
        builder: (context, state) => HomePage(),
      ),
    ],
  );
}