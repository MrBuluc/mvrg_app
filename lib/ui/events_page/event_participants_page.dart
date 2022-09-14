import 'package:flutter/material.dart';
import 'package:mvrg_app/model/events/participant.dart';
import 'package:mvrg_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class EventParticipantsPage extends StatefulWidget {
  final String eventTitle;
  final bool isParticipant;
  const EventParticipantsPage(
      {Key? key, required this.eventTitle, required this.isParticipant})
      : super(key: key);

  @override
  State<EventParticipantsPage> createState() => _EventParticipantsPageState();
}

class _EventParticipantsPageState extends State<EventParticipantsPage> {
  List<Participant>? participants;

  @override
  void initState() {
    super.initState();
    getParticipants();
  }

  Future getParticipants() async {
    participants = await Provider.of<UserModel>(context, listen: false)
        .getParticipants(widget.eventTitle, widget.isParticipant);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(!widget.isParticipant
            ? "Katılımcılar Listesi"
            : "Katılanlar Listesi"),
        centerTitle: true,
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (participants != null) {
      if (participants!.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(
                Icons.account_circle,
                size: 120,
              ),
              Text(
                "Henüz Kimse Listeye Eklenmemiştir",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 36),
              )
            ],
          ),
        );
      } else {
        return ListView(
          children: buildParticipants(),
        );
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  List<Widget> buildParticipants() {
    List<Widget> children = [];
    for (int i = 0; i < participants!.length; i++) {
      Participant participant = participants!.elementAt(i);
      Widget child = Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          leading: Text(
            (i + 1).toString(),
            style: const TextStyle(fontSize: 20),
          ),
          title: Text(
            participant.name!,
            style: const TextStyle(fontSize: 20),
          ),
          trailing: participant.isCurrentUser!
              ? GestureDetector(
                  child: const Icon(
                    Icons.remove,
                    color: Colors.red,
                  ),
                  onTap: () {},
                )
              : null,
        ),
      );
      children.add(child);
    }
    return children;
  }
}
