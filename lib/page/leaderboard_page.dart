import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:games_services/games_services.dart';
import 'package:toki/providers/styles.dart';
import 'package:toki/widget/page_title.dart';
import 'package:toki/widget/card_widget.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  Map<String, String> leaderboards = {
    'Matching Icons':'matchingIcons',
    'Maze':'maze',
  };

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: GamesServices.isSignedIn,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
            if (snapshot.data!) {
              return Scaffold(
                backgroundColor: context.read<Styles>().backgroundColor,
                body: SafeArea(
                  child: Column(
                    children: [
                      const PageTitle(
                        title: 'Leaderboard',
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: leaderboards.length,
                          itemBuilder: (BuildContext contxext, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: CardWidget(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      leaderboards.keys.toList()[index],
                                      style: context.watch<Styles>().alarmTitle,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            GamesServices.showLeaderboards(
                                              iOSLeaderboardID: '${leaderboards.values.toList()[index]}Easy'
                                            );
                                          },
                                          child: Text(
                                            'Easy',
                                            style: context.watch<Styles>().mediumTextDefault,
                                          ),
                                          style: context.watch<Styles>().leaderboardButton,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            GamesServices.showLeaderboards(
                                              iOSLeaderboardID: '${leaderboards.values.toList()[index]}Medium'
                                            );
                                          },
                                          child: Text(
                                            'Medium',
                                            style: context.watch<Styles>().mediumTextDefault,
                                          ),
                                          style: context.watch<Styles>().leaderboardButton,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            GamesServices.showLeaderboards(
                                              iOSLeaderboardID: '${leaderboards.values.toList()[index]}Hard'
                                            );
                                          },
                                          child: Text(
                                            'Hard',
                                            style: context.watch<Styles>().mediumTextDefault,
                                          ),
                                          style: context.watch<Styles>().leaderboardButton,
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              )
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Scaffold(
                backgroundColor: context.read<Styles>().backgroundColor,
                body: SafeArea(
                  child: Column(
                    children: [
                      const PageTitle(
                        title: 'Leaderboard',
                      ),
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextButton(
                              onPressed: () async {
                                await GamesServices.signIn();
                                if (await GamesServices.isSignedIn && mounted) {
                                  setState(() {});
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Sign in to game center to access the leaderboard',
                                  style: context.watch<Styles>().largeTextDefault,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              style: context.watch<Styles>().leaderboardButton,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
        } else {
          return Scaffold(
            backgroundColor: context.read<Styles>().backgroundColor,
            body: SafeArea(
              child: Column(
                children: const [
                   PageTitle(
                    title: 'Leaderboard',
                  ),
                  Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}