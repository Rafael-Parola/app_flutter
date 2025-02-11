import 'package:flutter/material.dart';
import '../../widget/cutom_app_bar/custom_app_bar.dart';
import '../../widget/spaces/resizer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: CustomAppBar(
          title: 'Agenda de medicamentos',
          centerTitle: false,
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Resizer.relativeWidth(context, 4),
              ),
              
            ),
          ],
        ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu Lateral', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: Text('Opção 1'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Opção 2'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Opção 3'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Center(child: Text('Conteúdo da página inicial')),
    );
  }
}
