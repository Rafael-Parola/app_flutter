import 'package:app_flutter/app/features/splash_page/splash_screen.dart';
import 'package:app_flutter/app/widget/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_flutter/app/features/home/home_page.dart';
import '../../widget/cutom_app_bar/custom_app_bar.dart';
import 'controller/settings_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final SettingsController _controller = SettingsController();

  String nome = 'Carregando...';
  String data = 'Carregando...';
  String email = 'Carregando...';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await _controller.loadData();
    setState(() {
      nome = data['nome'] ?? 'Não encontrado';
      this.data = data['data'] ?? 'Não encontrado';
      email = data['email'] ?? 'Não encontrado';
    });
  }

  void _logout() async {
    await _controller.logout();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SplashScreen()),
    );
  }

  Future<bool> _onWillPop() async {
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return WillPopScope(
      onWillPop: _onWillPop,  
      child: Scaffold(
        key: scaffoldKey,
        appBar: CustomAppBar(
          title: 'Configurações',
          centerTitle: true,
          leadingIcon: Icons.arrow_back_rounded,
          onPressedleading: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nome,
                    style: GoogleFonts.workSans(
                      textStyle: TextStyle(fontSize: 24),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    data,
                    style: GoogleFonts.workSans(
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    email,
                    style: GoogleFonts.workSans(
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            const Divider(),
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
              child: GestureDetector(
                onTap: _logout,
                child: Container(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app, color: CustomColors.black),
                      SizedBox(width: 10),
                      Text(
                        'Sair',
                        style: GoogleFonts.workSans(
                          textStyle:
                              TextStyle(fontSize: 18, color: CustomColors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
