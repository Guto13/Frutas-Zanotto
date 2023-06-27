import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/main.dart';
import 'package:maca_ipe/screens/estoque/estoque_screen.dart';
import 'package:maca_ipe/screens/produtores/produtores_screen.dart';
import 'package:maca_ipe/screens/produtos/Frutas/frutas_screen.dart';
import 'package:maca_ipe/screens/produtos/embalagens/embalagens_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LeftMenu extends StatelessWidget {
  const LeftMenu({
    Key? key,
    required this.client,
  }) : super(key: key);

  final SupabaseClient client;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: bgColor.withOpacity(0.9),
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(
              padding: const EdgeInsets.all(defaultPadding),
              child: Image.asset(
                'assets/images/Logo.png',
              ),
            ),
            MenuButton(
              title: 'Frutas',
              icon: 'assets/icons/apple.svg',
              press: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FrutasScreen()),
              ),
            ),
            MenuButton(
              title: 'Embalagens',
              icon: 'assets/icons/box.svg',
              press: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmbalagensScreen()),
              ),
            ),
            MenuButton(
              title: 'Produtores',
              icon: 'assets/icons/people.svg',
              press: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProdutoresScreen()),
              ),
            ),
            MenuButton(
              title: 'Estoque',
              icon: 'assets/icons/stock.svg',
              press: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EstoqueScreen()),
              ),
            ),
            MenuButton(
              title: 'Carga',
              icon: 'assets/icons/truck.svg',
              press: () {},
            ),
            MenuButton(
              title: 'Sair',
              icon: 'assets/icons/logout.svg',
              press: () {
                client.auth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String title;
  final String icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 0.0,
      onTap: press,
      leading: SvgPicture.asset(
        icon,
        height: 25,
      ),
      title: Text(
        title,
      ),
    );
  }
}
