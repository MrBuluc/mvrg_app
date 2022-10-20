import 'package:flutter/material.dart';
import 'package:mvrg_app/common_widget/center_text.dart';
import 'package:mvrg_app/ui/const.dart';
import 'package:qr_flutter/qr_flutter.dart';

class EventQrPage extends StatefulWidget {
  final String data;
  const EventQrPage({Key? key, required this.data}) : super(key: key);

  @override
  State<EventQrPage> createState() => _EventQrPageState();
}

class _EventQrPageState extends State<EventQrPage> {
  late Size size;

  TextEditingController codeCnt = TextEditingController();

  @override
  void initState() {
    super.initState();
    codeCnt.text = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          buildHeader(),
          buildQr(),
          SizedBox(
            height: size.height * .01,
          ),
          buildCode()
        ],
      ),
    );
  }

  Widget buildHeader() => Container(
        height: 200,
        width: size.width,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35)),
            color: qrColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CenterText(
              text: "Katılmak İçin Qr",
              textStyle: headerText,
            )
          ],
        ),
      );

  Widget buildQr() {
    double bodyHeight = size.height - MediaQuery.of(context).viewInsets.bottom;
    double qrImageSize = bodyHeight * .5;
    double embeddedImageSize = qrImageSize * .3;
    return Container(
      color: const Color(0xFFFFFFFF),
      child: Column(
        children: [
          Center(
            child: RepaintBoundary(
              child: QrImage(
                data: widget.data,
                version: QrVersions.auto,
                size: qrImageSize,
                gapless: false,
                embeddedImage: const AssetImage("assets/MvRG_Token.png"),
                embeddedImageStyle: QrEmbeddedImageStyle(
                    size: Size(embeddedImageSize, embeddedImageSize)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCode() => Expanded(
          child: Padding(
        padding: EdgeInsets.only(left: size.width * .03),
        child: TextFormField(
          controller: codeCnt,
          readOnly: true,
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
          decoration: const InputDecoration(border: InputBorder.none),
        ),
      ));
}
