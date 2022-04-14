import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toki/providers/styles.dart';
import 'package:toki/widget/page_title.dart';
import 'package:toki/widget/puzzle_widget.dart';
import 'package:toki/model/puzzle.dart';
import 'package:toki/backend/database_helpers.dart';

class PuzzlePage extends StatefulWidget {
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  _PuzzlePageState createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  late List<Puzzle> puzzles = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshPuzzles();
  }

  @override
  void dispose() {
    //TokiDatabase.instance.close();

    super.dispose();
  }

  Future refreshPuzzles() async {
    setState(() => isLoading = true);

    List<Puzzle> prePuzzles = await TokiDatabase.instance.readAllPuzzles();
    if (mounted) {
      setState(() {
        puzzles = prePuzzles;
      });
    }
    
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.read<Styles>().selectedAccentColor,
    body: SafeArea(
      child: Container(
        color: context.read<Styles>().backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const PageTitle(
              title: 'Puzzles',
            ),
            Expanded(
              child: isLoading
                ? const Center(
                    child: CircularProgressIndicator()
                  )
                : puzzles.isEmpty
                  ? Center(
                      child: Text(
                        'No Puzzles',
                        style: context.watch<Styles>().largeTextDefault,
                      ),
                    )
                  : buildPuzzles(),
            ),
          ]
        ),
      ),
    ),
  );

  Widget buildPuzzles() => ListView.builder(
    itemCount: puzzles.length,
    itemBuilder: (context, index) {
      final puzzle = puzzles[index];

      return PuzzleWidget(puzzle: puzzle, refreshFunc: refreshPuzzles);
    },
  );
}
