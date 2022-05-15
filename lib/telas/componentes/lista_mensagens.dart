import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatsappweb/modelos/mensagem.dart';
import 'package:whatsappweb/modelos/usuario.dart';
import 'package:whatsappweb/uteis/paleta_cores.dart';

class ListaMensagens extends StatefulWidget {
  final Usuario usuarioRemetente;
  final Usuario usuarioDestinatario;

  const ListaMensagens({
    Key? key,
    required this.usuarioRemetente,
    required this.usuarioDestinatario,
  }) : super(key: key);

  @override
  State<ListaMensagens> createState() => _ListaMensagensState();
}

class _ListaMensagensState extends State<ListaMensagens> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _controllerMensagem = TextEditingController();
  late Usuario _usuarioRemetente;
  late Usuario _usuarioDestinatario;

  _enviarMensagem() {
    String textoMensagem = _controllerMensagem.text;
    String idUsuarioRemetente = _usuarioRemetente.idUsuario;

    if (textoMensagem.isNotEmpty) {
      Mensagem mensagem = Mensagem(
          idUsuarioRemetente, textoMensagem, Timestamp.now().toString());

      String idUsuarioDetinatario = _usuarioDestinatario.idUsuario;
      _salvarMensagem(idUsuarioRemetente, idUsuarioDetinatario, mensagem);
    }
  }

  _salvarMensagem(
      String idRemetente, String idDestinatario, Mensagem mensagem) {
    _firestore
        .collection("mensagens")
        .doc(idRemetente)
        .collection(idDestinatario)
        .add(mensagem.toMap());

    _controllerMensagem.clear();
  }

  _recuperarDadosIniciais() {
    _usuarioRemetente = widget.usuarioRemetente;
    _usuarioDestinatario = widget.usuarioDestinatario;
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosIniciais();
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;

    return Container(
      width: largura,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("imagens/bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          //Listagem de mensagens
          Expanded(
            child: Container(
              width: largura,
              color: Colors.orange,
              child: const Text("Lista mensagem"),
            ),
          ),

          //Caixa de texto
          Container(
            padding: const EdgeInsets.all(8),
            color: PaletaCores.corFundoBarra,
            child: Row(
              children: [
                //Caixa de texto arredondada
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.insert_emoticon),
                        const SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _controllerMensagem,
                            decoration: const InputDecoration(
                                hintText: "Digite uma mensagem",
                                border: InputBorder.none),
                          ),
                        ),
                        const Icon(Icons.attach_file),
                        const Icon(Icons.camera_alt),
                      ],
                    ),
                  ),
                ),

                //Botao Enviar
                FloatingActionButton(
                  backgroundColor: PaletaCores.corPrimaria,
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  mini: true,
                  onPressed: () {
                    _enviarMensagem();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
