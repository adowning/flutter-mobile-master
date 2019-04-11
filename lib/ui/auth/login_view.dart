import 'package:flutter/material.dart';
import 'package:invoiceninja_flutter/ui/app/buttons/elevated_button.dart';
import 'package:invoiceninja_flutter/ui/app/progress_button.dart';
import 'package:invoiceninja_flutter/ui/auth/login_vm.dart';
import 'package:invoiceninja_flutter/ui/auth/scan_widget.dart';
import 'package:invoiceninja_flutter/utils/formatting.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';
import 'package:invoiceninja_flutter/ui/app/form_card.dart';
import 'package:invoiceninja_flutter/utils/keys.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final LoginVM viewModel;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginView> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _urlController = TextEditingController();
  final _secretController = TextEditingController();
  final _oneTimePasswordController = TextEditingController();

  static const String OTP_ERROR = 'OTP_REQUIRED';
  static bool _isScanning;

  static final ValueKey _emailKey = Key(LoginKeys.email);
  static final ValueKey _passwordKey = Key(LoginKeys.password);
  static final ValueKey _urlKey = Key(LoginKeys.url);
  static final ValueKey _secretKey = Key(LoginKeys.secret);
  static final ValueKey _oneTimePasswordKey = Key(LoginKeys.oneTimePassword);

  final FocusNode _focusNode1 = new FocusNode();

  bool _isSelfHosted = false;
  bool _autoValidate = false;

  @override
  void didChangeDependencies() {
    final state = widget.viewModel.authState;
    _emailController.text = state.email;
    _passwordController.text = state.password;
    _urlController.text = formatApiUrlReadable(state.url);
    _secretController.text = state.secret;
    _isScanning = false;
    //     controller = new AnimationController(
    //     vsync: this, duration: new Duration(milliseconds: 1500));
    // animation = new Tween(begin: 0.0, end: 1.0).animate(
    //     new CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn));
    // animation.addListener(() => this.setState(() {}));
    // controller.forward();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _urlController.dispose();
    _secretController.dispose();
    _isScanning = false;

    super.dispose();
  }

  void _submitForm() {
    // final bool isValid = _formKey.currentState.validate();

    // setState(() {
    //   _autoValidate = !isValid;
    // });

    // if (!isValid) {
    //   return;
    // }

    // widget.viewModel.onLoginPressed(context,
    //     email: _emailController.text,
    //     password: _passwordController.text,
    //     url: _urlController.text,
    //     secret: _secretController.text,
    //     oneTimePassword: _oneTimePasswordController.text);

    widget.viewModel.onLoginPressed(context,
        email: 'ashdowning@gmail.com',
        password: 'asdfasdf',
        url: 'https://billing.ashdevtools.com',
        secret: 'password',
        oneTimePassword: '');
  }

  Widget _scannerView() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final viewModel = widget.viewModel;
    final error = viewModel.authState.error ?? '';
    final isOneTimePassword =
        error.contains(OTP_ERROR) || _oneTimePasswordController.text.isNotEmpty;

    if (!viewModel.authState.isInitialized) {
      return Container();
    }

    return Stack(
      children: <Widget>[
        SizedBox(
          height: 250.0,
          child: ClipPath(
            clipper: ArcClipper(),
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  //Colors.grey.shade800,
                  //Colors.black87,
                  Theme.of(context).buttonColor,
                  Theme.of(context).buttonColor.withOpacity(.7),
                ],
              )),
            ),
          ),
        ),
        ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Image.asset('assets/images/logo.png',
                  width: 100.0, height: 100.0),
            ),
            (!_isScanning)
                ? Form(
                    key: _formKey,
                    child: FormCard(
                      children: <Widget>[
                        Container(width: 300, height: 250),
                        ProgressButton(
                          padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                          isLoading: viewModel.isLoading,
                          label: localization.login.toUpperCase(),
                          // onPressed: () => _submitForm(),
                          onPressed: () => setState(() {
                                _isScanning = true;
                              }),
                        )
                      ],
                    ),
                  )
                : ScanWidget(viewModel: viewModel),
          ],
        ),
      ],
    );
  }
}

// https://github.com/iampawan/Flutter-UI-Kit
class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 30);

    final firstControlPoint = Offset(size.width / 4, size.height);
    final firstPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    final secondControlPoint =
        Offset(size.width - (size.width / 4), size.height);
    final secondPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
