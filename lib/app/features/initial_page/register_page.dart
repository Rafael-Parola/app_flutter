import 'package:app_flutter/app/features/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widget/colors/colors.dart';
import '../../widget/custom_alert_dialog/custom_alert_dialog.dart';
import '../../widget/custom_button/custom_button.dart';
import '../../widget/custom_text/custom_text.dart';
import '../../widget/cutom_app_bar/custom_app_bar.dart';
import '../../widget/spaces/resizer.dart';
import '../../widget/utils/textinputformatter.dart';
import 'controller/register_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  Future<void> _initializeForm() async {
    final controller = Provider.of<RegisterController>(context, listen: false);
    await controller.initializeForm(_nomeController, _dataController, _emailController);

    if (await controller.hasData()) {
      // Avança automaticamente se os dados estiverem presentes
      _continueRegistration();
    }
  }

  void _continueRegistration() async {
    final controller = Provider.of<RegisterController>(context, listen: false);
    await controller.saveData('nome', _nomeController.text);
    await controller.saveData('data', _dataController.text);
    await controller.saveData('email', _emailController.text);

    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => CustomAlertDialog(
        message: "Cadastro realizado com sucesso \n Você será redirecionado em instantes",
        backgroundColor: CustomColors.green,
        textColor: CustomColors.white,
        duration: 3,
        onDismiss: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
      ),
    );
    Overlay.of(context).insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<RegisterController>(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Bem Vindo',
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Resizer.relativeWidth(context, 4),
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CustomTextField(
                    controller: _nomeController,
                    labelText: 'Nome Completo',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o nome completo.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    controller: _dataController,
                    labelText: 'Data de Nascimento',
                    hintText: 'DD/MM/AAAA',
                    keyboardType: TextInputType.datetime,
                    inputFormatters: [DateInputFormatter()],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a data de nascimento.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'E-mail',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o e-mail.';
                      } else if (!RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                          .hasMatch(value)) {
                        return 'Por favor, insira um e-mail válido.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: CustomButton(
                      text: 'Continuar',
                      width: double.infinity, 
                      backgroundColor: CustomColors.green.shade600,
                      textColor: CustomColors.white,
                      borderRadius: 12.0,
                      fontSize: 16.0,
                      onPressed: _continueRegistration,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
