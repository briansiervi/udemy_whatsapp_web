import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:whatsappweb/modelos/usuario.dart';
import 'package:whatsappweb/uteis/paleta_cores.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _controllerNome =
      TextEditingController(text: "Scorpion");
  final TextEditingController _controllerEmail =
      TextEditingController(text: "scorpion@gmail.com");
  final TextEditingController _controllerSenha =
      TextEditingController(text: "1234567");
  bool _cadastroUsuario = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Uint8List? _arquivoImagemSelecionado;

  void _verificarUsuarioLogado() {
    User? usuarioLogado = _auth.currentUser;

    if (usuarioLogado != null) {
      Navigator.pushReplacementNamed(context, "/home");
    }
  }

  void _selecionarImagem() async {
    //Selecionar o arquivo
    FilePickerResult? resultado =
        await FilePicker.platform.pickFiles(type: FileType.image);

    //Recuperar o arquivo
    setState(() {
      _arquivoImagemSelecionado = resultado?.files.single.bytes;
    });
  }

  _uploadImagem(Usuario usuario, UserCredential auth) async {
    Uint8List? arquivoSelecionado = _arquivoImagemSelecionado;
    if (arquivoSelecionado != null) {
      Reference imagemPerfilRef =
          _storage.ref("imagens/perfil/${usuario.idUsuario}.jpg");
      UploadTask uploadTask = imagemPerfilRef.putData(arquivoSelecionado);
      uploadTask.whenComplete(() async {
        //print("Link da imagem: $linkImagem");
        String urlImagem = await uploadTask.snapshot.ref.getDownloadURL();
        usuario.urlImagem = urlImagem;

        await auth.user?.updateDisplayName(usuario.nome);
        await auth.user?.updatePhotoURL(usuario.urlImagem);

        final usuariosRef = _firestore.collection("usuarios");
        usuariosRef.doc(usuario.idUsuario).set(usuario.toMap()).then((value) {
          //tela principal
          Navigator.pushReplacementNamed(context, "/home");
        });
      });
    }
  }

  static Route<dynamic> _dadosInvalidos(String corpoMensagem) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Mensagem"),
        ),
        body: Center(
          child: Text(corpoMensagem),
        ),
      );
    });
  }

  void _validarCampos() async {
    String nome = _controllerNome.text;
    String? email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty && senha.length > 6) {
        if (_cadastroUsuario) {
          if (_arquivoImagemSelecionado != null) {
            //Cadastro
            if (nome.isNotEmpty && nome.length >= 3) {
              await _auth
                  .createUserWithEmailAndPassword(email: email, password: senha)
                  .then((auth) async {
                //Upload da imagem
                String? idUsuario = auth.user?.uid;

                if (idUsuario != null) {
                  Usuario usuario = Usuario(idUsuario, nome, email);
                  await _uploadImagem(usuario, auth);
                }

                //print("Usuário cadastrado: $idUsuario");
              });
            } else {
              const Text("Nome inválido, digite ao menos 3 caracteres");
            }
          } else {
            _dadosInvalidos("Selecione uma imagem");
          }
        } else {
          try {
            //String? email2;
            await _auth
                .signInWithEmailAndPassword(email: email, password: senha)
                //.then((auth) => {email2 = auth.user?.email});
                .then(
                    (auth) => Navigator.pushReplacementNamed(context, "/home"));

            //print("Usuário logado: $email2");
          } catch (e) {
            _dadosInvalidos("Usuário inválido: $email");
          }
        }
      } else {
        const Text("Senha inválida");
      }
    } else {
      const Text("Email inválido");
    }
  }

  @override
  void initState() {
    super.initState();
    _verificarUsuarioLogado();
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
                                  child: _arquivoImagemSelecionado != null
                                      ? Image.memory(
                                          _arquivoImagemSelecionado!,
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
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
                                  onPressed: _selecionarImagem,
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
