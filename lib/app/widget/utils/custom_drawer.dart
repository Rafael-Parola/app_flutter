import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  final String? name;
  final String? email;
  final Future<void> Function()? onLogout;

  const CustomDrawer({
    super.key,
    this.name,
    this.email,
    this.onLogout,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                const SizedBox(height: 50.0),
                if (widget.name != null && widget.email != null)
                  ListTile(
                    title: Text(widget.name!),
                    subtitle: Text(widget.email!),
                    onTap: () {},
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                if (widget.onLogout != null)
                  ElevatedButton(
                    onPressed: widget.onLogout,
                    child: const Text('Logout'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
