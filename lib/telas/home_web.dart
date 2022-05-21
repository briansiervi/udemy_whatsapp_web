import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappweb/modelos/usuario.dart';
import 'package:whatsappweb/provider/conversa_provider.dart';
import 'package:whatsappweb/telas/componentes/lista_conversas.dart';
import 'package:whatsappweb/telas/componentes/lista_mensagens.dart';
import 'package:whatsappweb/uteis/paleta_cores.dart';
import 'package:whatsappweb/uteis/responsivo.dart';
import 'package:provider/provider.dart';

class HomeWeb extends StatefulWidget {
  const HomeWeb({Key? key}) : super(key: key);

  @override
  State<HomeWeb> createState() => _HomeWebState();
}

class _HomeWebState extends State<HomeWeb> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Usuario _usuarioLogado;

  _recuperarDadosUsuarioLogado() {
    User? usuarioLogado = _auth.currentUser;

    if (usuarioLogado != null) {
      String idUsuario = usuarioLogado.uid;
      String? nome = usuarioLogado.displayName ?? "";
      String? email = usuarioLogado.email ?? "";
      String? urlImagem = usuarioLogado.photoURL ?? "";

      _usuarioLogado = Usuario(
        idUsuario,
        nome,
        email,
        urlImagem: urlImagem,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;
    final altura = MediaQuery.of(context).size.height;
    final isWeb = Responsivo.isWeb(context);

    return Scaffold(
      body: Container(
        color: PaletaCores.corFundo,
        child: Stack(
          children: [
            Positioned(
                top: 0,
                child: Container(
                  color: PaletaCores.corPrimaria,
                  width: largura,
                  height: altura * 0.2,
                )),
            Positioned(
                top: isWeb ? altura * 0.05 : 0,
                bottom: isWeb ? altura * 0.05 : 0,
                left: isWeb ? largura * 0.05 : 0,
                right: isWeb ? largura * 0.05 : 0,
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: AreaLateralConversas(
                        usuarioLogado: _usuarioLogado,
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: AreaLateralMensagens(
                        usuarioLogado: _usuarioLogado,
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class AreaLateralConversas extends StatelessWidget {
  final Usuario usuarioLogado;

  const AreaLateralConversas({Key? key, required this.usuarioLogado})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: PaletaCores.corFundoBarraClaro,
          border: Border(
              right: BorderSide(
            color: PaletaCores.corFundo,
            width: 1,
          ))),
      child: Column(
        children: [
          //Barra superior
          Container(
            color: PaletaCores.corFundoBarra,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey,
                  backgroundImage:
                      CachedNetworkImageProvider(usuarioLogado.urlImagem),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.message),
                ),
                IconButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, "/login");
                  },
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
          ),

          //Barra de pesquisa
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                ),
                const Expanded(
                    child: TextField(
                  decoration: InputDecoration.collapsed(
                      hintText: "Pesquisar uma coversa"),
                )),
              ],
            ),
          ),

          //Lista de conversas
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: const ListaConversas(),
            ),
          ),
        ],
      ),
    );
  }
}

class AreaLateralMensagens extends StatelessWidget {
  final Usuario usuarioLogado;

  const AreaLateralMensagens({Key? key, required this.usuarioLogado})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;
    final altura = MediaQuery.of(context).size.height;
    Usuario? usuarioDestinatario =
        context.watch<ConversaProvider>().usuarioDestinatario;

    return usuarioDestinatario != null
        ? Column(
            children: [
              //Barra superior
              Container(
                color: PaletaCores.corFundoBarra,
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      backgroundImage: CachedNetworkImageProvider(
                          usuarioDestinatario.urlImagem),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      usuarioDestinatario.nome,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert),
                    ),
                  ],
                ),
              ),

              //Listagem de mensagens
              Expanded(
                child: ListaMensagens(
                    usuarioRemetente: usuarioLogado,
                    usuarioDestinatario: usuarioDestinatario),
              ),
            ],
          )
        : Container(
            width: largura,
            height: altura,
            color: PaletaCores.corFundoBarraClaro,
            child: const Center(
              child: Text("Nenhum usuário selecionado no momento"),
            ),
          );
  }
}
