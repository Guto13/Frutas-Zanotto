// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, library_private_types_in_public_api, sort_child_properties_last, await_only_futures

import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/screens/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://ecbgtnpomrushcntckhp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVjYmd0bnBvbXJ1c2hjbnRja2hwIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODY2NTYxMTMsImV4cCI6MjAwMjIzMjExM30.q4zJzqrEdGjWbugIRppWCtZ7W3mMTpad3TmxWdKiBGo',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeData theme = ThemeData();

  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Minha Firma',
        theme: ThemeData(
          scaffoldBackgroundColor: bgColor.withOpacity(0.9),
          primarySwatch: Colors.green,
        ),
        home: LoginScreen());
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _email = "macaipe.ltd5@gmail.com";
  late String _password;
  final client = Supabase.instance.client;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  void checkAuthentication() async {
    final response = await client.auth.currentUser;

    if (response != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(defaultPadding) ,
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/images/Logo.png'),
                      const SizedBox(height: 30.0),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 600),
                        child: Container(
                          padding: EdgeInsets.all(defaultPadding) ,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 15.0,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'E-mail',
                                    prefixIcon: Icon(Icons.email),
                                  ),
                                  initialValue: _email,
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Por favor, preencha este campo';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => _email = value!,
                                ),
                                SizedBox(height: 10.0),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Senha',
                                    prefixIcon: Icon(Icons.key),
                                  ),
                                  obscureText: true,
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Por favor, preencha este campo';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => _password = value!,
                                  onFieldSubmitted: (_) => _login(),
                                ),
                                SizedBox(height: 20.0),
                                BotaoPadrao(
                                    context: context,
                                    title: "Entrar",
                                    onPressed: _login)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        await client.auth
            .signInWithPassword(email: _email, password: _password);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } on AuthException catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Ocorreu um erro, tente novamente!"),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
