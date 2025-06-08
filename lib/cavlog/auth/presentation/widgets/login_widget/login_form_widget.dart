import 'package:barber_pannel/core/common/snackbar_helper.dart';
import 'package:barber_pannel/core/routes/routes.dart';
import 'package:barber_pannel/core/themes/colors.dart';
import 'package:barber_pannel/core/validation/input_validations.dart';
import 'package:barber_pannel/cavlog/auth/presentation/provider/bloc/Login_bloc/login_bloc.dart';
import 'package:barber_pannel/cavlog/auth/presentation/widgets/login_widget/handle_login_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/common/common_action_button.dart';
import '../../../../../core/common/textfield_helper.dart';
import '../../../../../core/utils/constant/constant.dart';
import '../../../data/repositories/auth_repository_impl.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.screenHight,
    required this.screenWidth,
    required this.formKey,
  });

  final double screenHight;
  final double screenWidth;
  final GlobalKey<FormState> formKey;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          TextFormFieldWidget(
            label: 'Email',
            hintText: 'Enter email id',
            prefixIcon: CupertinoIcons.mail_solid,
            controller: emailController,
            validate: ValidatorHelper.validateEmailId,
          ),
          TextFormFieldWidget(
            label: 'Password',
            hintText: 'Enter Password',
            prefixIcon: CupertinoIcons.padlock_solid,
            isPasswordField: true,
            controller: passwordController,
            validate: ValidatorHelper.loginValidation,
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.resetPassword,
                  arguments: true);
            },
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'Forgot Password?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ConstantWidgets.hight20(context),
          BlocProvider(
            create: (context) => LoginBloc(AuthRepositoryImpl()),
            child: BlocListener<LoginBloc, LoginState>(
              listener: (context, state) {
                handleLoginState(context, state, emailController,passwordController);
              },
              child: Builder(
                builder: (context) {
                  final loginBloc = context.read<LoginBloc>();

                  return ActionButton(
                    screenHight: widget.screenHight,
                    screenWidth: widget.screenWidth,
                    label: 'Sign In',
                    onTap: () async {
                      if (widget.formKey.currentState!.validate()) {
                        loginBloc.add(LoginActionEvent(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          context,
                        ));
                      } else {
                        CustomeSnackBar.show(
                          context: context,
                          title: 'Submission Faild',
                          description:'Please fill in all the required fields before proceeding..',
                          titleClr: AppPalette.blackClr,
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ),
          ConstantWidgets.hight10(context),
        ],
      ),
    );
  }
}
