import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

import '../../../../core/extensions/string_extansion.dart';
import '../../../../core/init/lang/locale_keys.g.dart';
import '../../../../core/init/network/service/network_service.dart';
import '../../../../core/init/routes/routes.gr.dart';
import '../../../../core/utils/custom_error_widgets.dart';
import '../../../../core/widgets/button/button.dart';
import '../../../../core/widgets/divider/divider_widget.dart';
import '../../../../core/widgets/text/text.dart';
import '../../../../core/widgets/textfield/textfield_widget.dart';
import '../../../../core/widgets/top/auth_top_widget.dart';

import '../../../favorite/bloc/favorite_bloc.dart';
import '../../bloc/auth_bloc.dart';
import '../bloc/cubit/component_cubit.dart';
import '../model/login_request_model.dart';

/*
1
johnd 
m38rmF$

2
mor_2314
83r5^_

3
kevinryan
kev02937@

4
valerie
ewedon

5
derek
jklg*_56

6
david_r
3478*#54

7
snyder
f238&@*$

8
hopkins
William56$hj

9
kate_h
kfejk@*_

10
jimmie_k
klein*#%*
*/

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final manager = NetworkService.instance.networkManager;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController unameController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    unameController = TextEditingController();
    passwordController = TextEditingController();
    BlocProvider.of<FavoriteBloc>(context).add(FavoriteEvent.init(favList: []));
    super.initState();
  }

  @override
  void dispose() {
    unameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: context.horizontalPaddingMedium,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: context.isKeyBoardOpen
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                AuthTopWidget(
                    ctx: context,
                    title: LocaleKeys.login_topTitle.locale,
                    subTitle: LocaleKeys.login_topMessage.locale,
                    image: 'auth'),

                Padding(padding: context.paddingLow),
                _buildUnameInput(),
                Padding(padding: context.paddingLow),
                _buildPassInput(context),
                //*forgot password
                _buildForgotButton(),
                //*sign in button
                BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
                  if (state is LoginError) {
                    CustomErrorWidgets.showError(
                        context, state.error.toString());
                  }
                }, builder: (context, state) {
                  return _buildButton(state, context);
                }),

                Padding(padding: context.paddingLow),
                //*signup-or-social text
                RichTextWidget(
                    actionName: LocaleKeys.login_register.locale,
                    text: LocaleKeys.login_haveAccount.locale,
                    action: () => context.router.push(const RegisterView())),
                const DividerWidget(),
                //*social button
                const SocialIconButtonWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }

  EButtonWidget _buildButton(AuthState state, BuildContext context) {
    return EButtonWidget(
        loading: state is LoginLoading || state is LoginSuccess,
        text: LocaleKeys.login_buttonText.locale,
        onPress: () {
          if (_formKey.currentState!.validate()) {
            context.read<AuthBloc>().add(AuthEvent.login(
                manager: manager,
                scaffoldKey: scaffoldKey,
                loginRequestModel: LoginRequestModel(
                  username: unameController.text.trim(),
                  password: passwordController.text.trim(),
                ),
                context: context));
          }
        });
  }

  Widget _buildPassInput(BuildContext context) {
    final visibility = context.watch<LoginCubit>().state.visibility;
    return TextFieldWidget(
        keyType: TextInputType.name,
        actionType: TextInputAction.done,
        controller: passwordController,
        pIcon: Icons.lock_outlined,
        sIcon: visibility
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
        suffixOnPress: () =>
            context.read<LoginCubit>().toogleSuffixIcon(!visibility),
        obscureText: visibility ? false : true,
        labelText: 'Password',
        hintText: LocaleKeys.login_tfieldPassHint.locale);
  }

  TextFieldWidget _buildUnameInput() {
    return TextFieldWidget(
        keyType: TextInputType.name,
        actionType: TextInputAction.next,
        controller: unameController,
        pIcon: Icons.person_outlined,
        labelText: 'UserName',
        hintText: LocaleKeys.login_tfieldUnameHint.locale);
  }

  Align _buildForgotButton() {
    return Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () => context.router.push(const ForgotView()),
          child: Text(
            LocaleKeys.login_forgot.locale,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(decoration: TextDecoration.underline),
          ),
        ));
  }
}
