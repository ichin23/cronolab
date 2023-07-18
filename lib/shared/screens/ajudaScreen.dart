import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/components/cardAnimatedOnHover.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class AjudaScreen extends StatefulWidget {
  const AjudaScreen({Key? key}) : super(key: key);

  @override
  State<AjudaScreen> createState() => _AjudaScreenState();
}

class _AjudaScreenState extends State<AjudaScreen> {
  int tamanhoAtual = 3;
  Future<List<Map>> loadHelps = Future.value([]);

  @override
  void initState() {
    super.initState();
    loadHelps = FirebaseFirestore.instance.collection("help").get().then(
        (value) => value.docs.map((e) => {...e.data(), "id": e.id}).toList());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder<List<Map>>(
          future: loadHelps,
          builder: (context, snap) {
            tamanhoAtual = snap.data?.length ?? 0;
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        const Center(
                          child: Text(
                            "Dificuldades com o Cronolab?",
                            style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 28,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          width: size.width * 0.9,
                          constraints: const BoxConstraints(maxWidth: 450),
                          child: TextField(
                            style: const TextStyle(color: whiteColor),
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: "Buscar...",
                              contentPadding: const EdgeInsets.only(left: 20),
                              suffixIcon: const Icon(
                                Icons.search,
                                color: primaryDark,
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide: const BorderSide(
                                      color: darkPrimary, width: 2)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide: const BorderSide(
                                      color: darkPrimary, width: 3)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
                snap.connectionState == ConnectionState.waiting
                    ? const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()))
                    : SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: size.width > 800
                                      ? (size.width - 50) / 3
                                      : size.width * 0.9,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: size.width > 800
                                      ? 36 / 20
                                      : size.width * 0.9 / 115),
                          delegate: SliverChildBuilderDelegate(
                            (context, i) => CardAnimatedOnHover(
                              width: size.width > 800
                                  ? (size.width - 50) / 3
                                  : size.width * 0.9,
                              height: size.width > 800
                                  ? 20 * ((size.width - 50) / 3) / 36
                                  : 115,
                              color: darkPrimary,
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snap.data![i]["title"],
                                      style: const TextStyle(
                                          fontSize: 22,
                                          color: whiteColor,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(snap.data![i]["descricao"]),
                                  ],
                                ),
                              ),
                            ),
                            childCount: snap.data?.length ?? 0,
                          ),
                          /*child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 25),
                                      height: size.height * 0.7,
                                      width: size.width,
                                      constraints: BoxConstraints(minHeight: size.height * 0.7),
                                      child: */
                        ),
                      ),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 12),
                  sliver: SliverList(
                      delegate: SliverChildListDelegate(
                    [
                      const Text(
                        "Não encontrou sua dúvida?",
                        textAlign: TextAlign.center,
                      ),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            const TextSpan(
                                text: "Entre em contato ",
                                style: TextStyle(color: whiteColor)),
                            TextSpan(
                                text: "cronolabtcc@gmail.com",
                                style: const TextStyle(color: darkPrimary),
                                mouseCursor: SystemMouseCursors.click,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    var email = Uri.encodeComponent(
                                        "cronolabtcc@gmail.com");
                                    Uri mail = Uri.parse("mailto:$email");

                                    if (await launchUrl(mail)) {
                                    } else {
                                      Clipboard.setData(
                                              ClipboardData(text: email))
                                          .then((_) {
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                const AlertDialog(
                                                  content: Text(
                                                      "Sem app padrão de email definido. Endereço copiado para a área de transferência"),
                                                ));
                                      });
                                    }
                                  }),
                            const TextSpan()
                          ])),
                    ],
                  )),
                )
              ],
            );
          }),
    );
  }
}
