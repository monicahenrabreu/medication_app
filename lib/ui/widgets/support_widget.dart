import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportWidget extends StatelessWidget {
  const SupportWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          AppLocalizations.of(context)!.supportContact,
        ),
        const SizedBox(width: 20,),
        GestureDetector(
          onTap: _launchUrl,
          child: Icon(
            Icons.email,
            color: Theme.of(context).primaryColor,
            size: 30,
          ),
        ),
      ],
    );
  }

  void _launchUrl() async {
    final Uri _url = Uri.parse(
        'mailto:monica.i.h.abreu@gmail.com?subject=Medication%20App%20Support');

    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }
}
