import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappweb/uteis/paleta_cores.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _controllerNome =
      TextEditingController(text: "Mario");
  final TextEditingController _controllerEmail =
      TextEditingController(text: "mario@armario.com.br");
  final TextEditingController _controllerSenha =
      TextEditingController(text: "1234567");
  bool _cadastroUsuario = false;
  //FirebaseAuth _auth = FirebaseAuth.instance;

  void _validarCampos() async {
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty && senha.length > 6) {
        if (_cadastroUsuario) {
          //Cadastro
          if (nome.isNotEmpty && nome.length >= 3) {
            // await _auth
            //     .createUserWithEmailAndPassword(email: email, password: senha)
            //     .then((auth) {
            //   //Upload da imagem
            //   String? idUsuario = auth.user?.uid;
            //   print("Usuário cadastrado: $idUsuario");
            // });
          } else {
            const Text("Nome inválido, digite ao menos 3 caracteres");
          }
        } else {
          //Login
        }
      } else {
        const Text("Senha inválida");
      }
    } else {
      const Text("Email inválido");
    }
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: PaletaCores.corFundo,
        width: larguraTela,
        height: alturaTela,
        child: Stack(
          children: [
            Positioned(
                child: Container(
              width: larguraTela,
              height: alturaTela * 0.5,
              color: PaletaCores.corPrimaria,
            )),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    elevation: 4,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Container(
                      padding: const EdgeInsets.all(40),
                      width: 500,
                      child: Column(
                        children: [
                          Visibility(
                            visible: _cadastroUsuario,
                            child: Column(
                              children: [
                                ClipOval(
                                  child: Image.asset(
                                    "imagens/perfil.png",
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                OutlinedButton(
                                  onPressed: () {},
                                  child: const Text("Selecionar foto"),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextField(
                                  keyboardType: TextInputType.text,
                                  controller: _controllerNome,
                                  decoration: const InputDecoration(
                                      hintText: "Nome",
                                      labelText: "Nome",
                                      suffixIcon: Icon(Icons.person_outline)),
                                ),
                              ],
                            ),
                          ),
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _controllerEmail,
                            decoration: const InputDecoration(
                                hintText: "Email",
                                labelText: "Email",
                                suffixIcon: Icon(Icons.mail_outline)),
                          ),
                          TextField(
                            keyboardType: TextInputType.text,
                            controller: _controllerSenha,
                            obscureText: true,
                            decoration: const InputDecoration(
                                hintText: "Senha",
                                labelText: "Senha",
                                suffixIcon: Icon(Icons.lock_outline)),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: PaletaCores.corPrimaria),
                                  onPressed: () {
                                    _validarCampos();
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      _cadastroUsuario ? "Cadastrar" : "Logar",
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  )),
                            ),
                          ),
                          Row(
                            children: [
                              const Text("Logar"),
                              Switch(
                                  value: _cadastroUsuario,
                                  onChanged: (bool valor) {
                                    setState(() {
                                      _cadastroUsuario = valor;
                                    });
                                  }),
                              const Text("Cadastrar"),
                            ],
                          ),
                        ],
                      ),
                    ),
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
