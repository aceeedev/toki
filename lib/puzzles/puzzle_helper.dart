import 'package:flutter/material.dart';
import 'package:toki/backend/database_helpers.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:games_services/games_services.dart';
import 'package:toki/providers/styles.dart';
import 'package:toki/backend/notification_api.dart';
import 'package:toki/model/alarm.dart';
import 'package:toki/widget/page_title.dart';
import 'package:toki/widget/emergency_exit_button.dart';
import 'package:toki/puzzles/matching_icons.dart';
import 'package:toki/puzzles/maze.dart';
import 'package:toki/puzzles/complete_word.dart';
import 'package:toki/puzzles/hangman.dart';
import 'package:toki/puzzles/word_search.dart';
//import 'package:toki/puzzles/memory.dart';


class PuzzleHelper {
  static List<String> listOfWords = ['people', 'history', 'world', 'information', 'family', 'government', 'health', 'system', 'computer', 'thanks', 'music', 'person', 'reading', 'method', 'understanding', 'theory', 'literature', 'problem', 'software', 'control', 'knowledge', 'power', 'ability', 'economics', 'internet', 'television', 'science', 'library', 'nature', 'product', 'temperature', 'investment', 'society', 'activity', 'story', 'industry', 'media', 'thing', 'community', 'definition', 'safety', 'quality', 'development', 'language', 'management', 'player', 'variety', 'video', 'security', 'country', 'movie', 'organization', 'equipment', 'physics', 'analysis', 'policy', 'series', 'thought', 'basis', 'boyfriend', 'direction', 'strategy', 'technology', 'camera', 'freedom', 'paper', 'environment', 'child', 'instance', 'month', 'truth', 'marketing', 'university', 'writing', 'article', 'department', 'difference', 'audience', 'fishing', 'growth', 'income', 'marriage', 'combination', 'failure', 'meaning', 'medicine', 'philosophy', 'teacher', 'communication', 'night', 'chemistry', 'disease', 'energy', 'nation', 'advertising', 'location', 'success', 'addition', 'apartment', 'education', 'moment', 'painting', 'politics', 'attention', 'decision', 'event', 'property', 'shopping', 'student', 'competition', 'distribution', 'entertainment', 'office', 'population', 'president', 'category', 'cigarette', 'context', 'introduction', 'opportunity', 'performance', 'driver', 'flight', 'length', 'magazine', 'newspaper', 'relationship', 'teaching', 'dealer', 'finding', 'member', 'message', 'phone', 'scene', 'appearance', 'association', 'concept', 'customer', 'death', 'discussion', 'housing', 'inflation', 'insurance', 'woman', 'advice', 'blood', 'effort', 'expression', 'importance', 'opinion', 'payment', 'reality', 'responsibility', 'situation', 'skill', 'statement', 'wealth', 'application', 'county', 'depth', 'estate', 'foundation', 'grandmother', 'heart', 'perspective', 'photo', 'recipe', 'studio', 'topic', 'collection', 'depression', 'imagination', 'passion', 'percentage', 'resource', 'setting', 'agency', 'college', 'connection', 'criticism', 'description', 'memory', 'patience', 'secretary', 'solution', 'administration', 'aspect', 'attitude', 'director', 'personality', 'psychology', 'recommendation', 'response', 'selection', 'storage', 'version', 'alcohol', 'argument', 'complaint', 'contract', 'emphasis', 'highway', 'membership', 'possession', 'preparation', 'steak', 'union', 'agreement', 'cancer', 'currency', 'employment', 'engineering', 'entry', 'interaction', 'mixture', 'preference', 'region', 'republic', 'tradition', 'virus', 'actor', 'classroom', 'delivery', 'device', 'difficulty', 'drama', 'election', 'engine', 'football', 'guidance', 'hotel', 'owner', 'priority', 'protection', 'suggestion', 'tension', 'variation', 'anxiety', 'atmosphere', 'awareness', 'bread', 'candidate', 'climate', 'comparison', 'confusion', 'construction', 'elevator', 'emotion', 'employee', 'employer', 'guest', 'height', 'leadership', 'manager', 'operation', 'recording', 'sample', 'transportation', 'charity', 'cousin', 'disaster', 'editor', 'efficiency', 'excitement', 'extent', 'feedback', 'guitar', 'homework', 'leader', 'outcome', 'permission', 'presentation', 'promotion', 'reflection', 'refrigerator', 'resolution', 'revenue', 'session', 'singer', 'tennis', 'basket', 'bonus', 'cabinet', 'childhood', 'church', 'clothes', 'coffee', 'dinner', 'drawing', 'hearing', 'initiative', 'judgment', 'measurement', 'orange', 'poetry', 'police', 'possibility', 'procedure', 'queen', 'ratio', 'relation', 'restaurant', 'satisfaction', 'sector', 'signature', 'significance', 'tooth', 'vehicle', 'volume', 'accident', 'airport', 'appointment', 'arrival', 'assumption', 'baseball', 'chapter', 'committee', 'conversation', 'database', 'enthusiasm', 'error', 'explanation', 'farmer', 'historian', 'hospital', 'injury', 'instruction', 'maintenance', 'manufacturer', 'perception', 'presence', 'proposal', 'reception', 'replacement', 'revolution', 'river', 'speech', 'village', 'warning', 'winner', 'worker', 'writer', 'assistance', 'breath', 'buyer', 'chest', 'chocolate', 'conclusion', 'contribution', 'cookie', 'courage', 'drawer', 'establishment', 'examination', 'garbage', 'grocery', 'honey', 'impression', 'improvement', 'independence', 'insect', 'inspection', 'inspector', 'ladder', 'penalty', 'piano', 'potato', 'profession', 'professor', 'quantity', 'reaction', 'requirement', 'salad', 'sister', 'supermarket', 'tongue', 'weakness', 'wedding', 'affair', 'ambition', 'analyst', 'apple', 'assignment', 'assistant', 'bathroom', 'bedroom', 'birthday', 'celebration', 'championship', 'cheek', 'client', 'consequence', 'departure', 'diamond', 'fortune', 'friendship', 'funeral', 'girlfriend', 'indication', 'intention', 'midnight', 'negotiation', 'obligation', 'passenger', 'pizza', 'platform', 'pollution', 'recognition', 'reputation', 'shirt', 'speaker', 'stranger', 'surgery', 'sympathy', 'throat', 'trainer', 'uncle', 'youth', 'water', 'money', 'example', 'while', 'business', 'study', 'place', 'number', 'field', 'process', 'experience', 'point', 'economy', 'value', 'market', 'guide', 'interest', 'state', 'radio', 'course', 'company', 'price', 'trade', 'group', 'force', 'light', 'training', 'school', 'amount', 'level', 'order', 'practice', 'research', 'sense', 'service', 'piece', 'sport', 'house', 'answer', 'sound', 'focus', 'matter', 'board', 'picture', 'access', 'garden', 'range', 'reason', 'future', 'demand', 'exercise', 'image', 'cause', 'coast', 'action', 'record', 'result', 'section', 'building', 'mouse', 'class', 'nothing', 'period', 'store', 'subject', 'space', 'stock', 'weather', 'chance', 'figure', 'model', 'source', 'beginning', 'earth', 'program', 'chicken', 'design', 'feature', 'material', 'purpose', 'question', 'birth', 'object', 'scale', 'profit', 'speed', 'style', 'craft', 'inside', 'outside', 'standard', 'exchange', 'position', 'pressure', 'stress', 'advantage', 'benefit', 'frame', 'issue', 'cycle', 'metal', 'paint', 'review', 'screen', 'structure', 'account', 'discipline', 'medium', 'share', 'balance', 'black', 'bottom', 'choice', 'impact', 'machine', 'shape', 'address', 'average', 'career', 'culture', 'morning', 'table', 'condition', 'contact', 'credit', 'network', 'north', 'square', 'attempt', 'effect', 'voice', 'capital', 'challenge', 'friend', 'brush', 'couple', 'debate', 'front', 'function', 'living', 'plant', 'plastic', 'summer', 'taste', 'theme', 'track', 'brain', 'button', 'click', 'desire', 'influence', 'notice', 'damage', 'distance', 'feeling', 'savings', 'staff', 'sugar', 'target', 'animal', 'author', 'budget', 'discount', 'ground', 'lesson', 'minute', 'officer', 'phase', 'reference', 'register', 'stage', 'stick', 'title', 'trouble', 'bridge', 'campaign', 'character', 'evidence', 'letter', 'maximum', 'novel', 'option', 'plenty', 'quarter', 'weight', 'background', 'carry', 'factor', 'fruit', 'glass', 'joint', 'master', 'muscle', 'strength', 'traffic', 'vegetable', 'appeal', 'chart', 'ideal', 'kitchen', 'mother', 'party', 'principle', 'relative', 'season', 'signal', 'spirit', 'street', 'bench', 'commission', 'minimum', 'progress', 'project', 'south', 'status', 'stuff', 'ticket', 'angle', 'breakfast', 'confidence', 'daughter', 'degree', 'doctor', 'dream', 'essay', 'father', 'finance', 'juice', 'limit', 'mouth', 'peace', 'stable', 'storm', 'substance', 'trick', 'afternoon', 'beach', 'blank', 'catch', 'chain', 'consideration', 'cream', 'detail', 'interview', 'match', 'mission', 'pleasure', 'score', 'screw', 'shower', 'window', 'agent', 'block', 'calendar', 'contest', 'corner', 'court', 'district', 'finger', 'garage', 'guarantee', 'implement', 'layer', 'lecture', 'manner', 'meeting', 'parking', 'partner', 'profile', 'respect', 'routine', 'schedule', 'swimming', 'telephone', 'winter', 'airline', 'battle', 'bother', 'curve', 'designer', 'dimension', 'dress', 'emergency', 'evening', 'extension', 'fight', 'grade', 'holiday', 'horror', 'horse', 'husband', 'mistake', 'mountain', 'noise', 'occasion', 'package', 'patient', 'pause', 'phrase', 'proof', 'relief', 'sentence', 'shoulder', 'smoke', 'stomach', 'string', 'tourist', 'towel', 'vacation', 'wheel', 'aside', 'associate', 'border', 'branch', 'breast', 'brother', 'buddy', 'bunch', 'coach', 'cross', 'document', 'draft', 'expert', 'floor', 'habit', 'judge', 'knife', 'landscape', 'league', 'native', 'opening', 'parent', 'pattern', 'pound', 'request', 'salary', 'shame', 'shelter', 'silver', 'tackle', 'trust', 'assist', 'blame', 'brick', 'chair', 'closet', 'collar', 'comment', 'conference', 'devil', 'glove', 'jacket', 'lunch', 'monitor', 'mortgage', 'nurse', 'panic', 'plane', 'reward', 'sandwich', 'shock', 'spite', 'spray', 'surprise', 'transition', 'weekend', 'welcome', 'alarm', 'bicycle', 'blind', 'bottle', 'cable', 'candle', 'clerk', 'cloud', 'concert', 'counter', 'flower', 'grandfather', 'lawyer', 'leather', 'mirror', 'pension', 'plate', 'purple', 'skirt', 'slice', 'specialist', 'stroke', 'switch', 'trash', 'anger', 'award', 'bitter', 'candy', 'carpet', 'champion', 'channel', 'clock', 'comfort', 'crack', 'engineer', 'entrance', 'fault', 'grass', 'highlight', 'incident', 'island', 'motor', 'nerve', 'passage', 'pride', 'priest', 'prize', 'promise', 'resident', 'resort', 'scheme', 'script', 'station', 'tower', 'truck', 'witness', 'other', 'great', 'being', 'might', 'still', 'public', 'start', 'human', 'local', 'general', 'specific', 'tonight', 'common', 'change', 'simple', 'possible', 'particular', 'today', 'major', 'personal', 'current', 'national', 'natural', 'physical', 'check', 'second', 'increase', 'single', 'individual', 'guard', 'offer', 'potential', 'professional', 'international', 'travel', 'alternative', 'following', 'special', 'working', 'whole', 'dance', 'excuse', 'commercial', 'purchase', 'primary', 'worth', 'necessary', 'positive', 'produce', 'search', 'present', 'spend', 'creative', 'drive', 'green', 'support', 'remove', 'return', 'complex', 'effective', 'middle', 'regular', 'reserve', 'independent', 'leave', 'original', 'reach', 'serve', 'watch', 'beautiful', 'charge', 'active', 'break', 'negative', 'visit', 'visual', 'affect', 'cover', 'report', 'white', 'beyond', 'junior', 'unique', 'anything', 'classic', 'final', 'private', 'teach', 'western', 'concern', 'familiar', 'official', 'broad', 'comfortable', 'maybe', 'stand', 'young', 'heavy', 'hello', 'listen', 'valuable', 'worry', 'handle', 'leading', 'release', 'finish', 'normal', 'press', 'secret', 'spread', 'spring', 'tough', 'brown', 'display', 'objective', 'shoot', 'touch', 'cancel', 'chemical', 'extreme', 'conflict', 'formal', 'opposite', 'pitch', 'remote', 'total', 'treat', 'abuse', 'deposit', 'print', 'raise', 'sleep', 'somewhere', 'advance', 'anywhere', 'consist', 'double', 'equal', 'internal', 'sensitive', 'attack', 'claim', 'constant', 'drink', 'guess', 'minor', 'solid', 'weird', 'wonder', 'annual', 'count', 'doubt', 'forever', 'impress', 'nobody', 'repeat', 'round', 'slide', 'strip', 'whereas', 'combine', 'command', 'divide', 'equivalent', 'initial', 'march', 'mention', 'smell', 'spiritual', 'survey', 'adult', 'brief', 'crazy', 'escape', 'gather', 'prior', 'repair', 'rough', 'scratch', 'strike', 'employ', 'external', 'illegal', 'laugh', 'mobile', 'nasty', 'ordinary', 'respond', 'royal', 'senior', 'split', 'strain', 'struggle', 'train', 'upper', 'yellow', 'convert', 'crash', 'dependent', 'funny', 'permit', 'quote', 'recover', 'resolve', 'spare', 'suspect', 'sweet', 'swing', 'twist', 'upstairs', 'usual', 'abroad', 'brave', 'concentrate', 'estimate', 'grand', 'prompt', 'quiet', 'refuse', 'regret', 'reveal', 'shake', 'shift', 'shine', 'steal', 'surround', 'anybody', 'brilliant', 'delay', 'drunk', 'female', 'hurry', 'inevitable', 'invite', 'punch', 'reply', 'representative', 'resist', 'silly', 'smile', 'spell', 'stretch', 'stupid', 'temporary', 'tomorrow', 'yesterday'];

  static Stopwatch? stopwatch;
  Future<List<Map<String, Widget>>> createPuzzleList(BuildContext context) async {
    return [
      {'Matching Icons': MatchingIcons(
        completePuzzle: completePuzzle,
        difficulty: (await TokiDatabase.instance.readPuzzle(null, 'Matching Icons')).difficulty,
        test: false,
      )},
      {'Maze': MazePuzzle(
        completePuzzle: completePuzzle,
        difficulty: (await TokiDatabase.instance.readPuzzle(null, 'Maze')).difficulty,
        test: false,
      )},
      {'Complete the Word': CompleteWord(
        completePuzzle: completePuzzle,
        difficulty: (await TokiDatabase.instance.readPuzzle(null, 'Complete the Word')).difficulty,
        test: false,
      )},
      {'Hangman': Hangman(
        completePuzzle: completePuzzle,
        difficulty: (await TokiDatabase.instance.readPuzzle(null, 'Hangman')).difficulty,
        test: false,
      )},
      {'Word Search': WordSearchGame(
        completePuzzle: completePuzzle,
        difficulty: (await TokiDatabase.instance.readPuzzle(null, 'Word Search')).difficulty,
        test: false,
      )},
    ];
  } 

  /// returns [Widget randomPuzzle, String randomPuzzleName]
  Future<List<dynamic>> randomPuzzle(BuildContext context) async {
    final _random = Random();
    final List<Map<String, Widget>> puzzleList = await createPuzzleList(context);
    Map<String, Widget> randomPuzzle = puzzleList[_random.nextInt(puzzleList.length)];

    while(!(await TokiDatabase.instance.readPuzzle(null, randomPuzzle.keys.toList()[0])).enabled) {
      randomPuzzle = puzzleList[_random.nextInt(puzzleList.length)];
    }

    return [randomPuzzle.values.first, randomPuzzle.keys.toList().first];
  }

  static void completePuzzle(BuildContext context, bool test) async {
    if (!test) {
      NotificationApi.resetAlarm();
    }
    Navigator.pop(context);
  }

  static void openTestPuzzle(BuildContext context, String puzzleName, bool test) async {
    Widget? puzzleWidget;

    if (puzzleName == 'Matching Icons') {
      puzzleWidget = MatchingIcons(
        completePuzzle: completePuzzle,
        difficulty: (await TokiDatabase.instance.readPuzzle(null, 'Matching Icons')).difficulty,
        test: true,
      );
    } else if (puzzleName == 'Maze') {
      puzzleWidget = MazePuzzle(
        completePuzzle: completePuzzle,
        difficulty: (await TokiDatabase.instance.readPuzzle(null, 'Maze')).difficulty,
        test: true,
      );
    } else if (puzzleName == 'Complete the Word') {
      puzzleWidget = CompleteWord(
        completePuzzle: completePuzzle,
        difficulty: (await TokiDatabase.instance.readPuzzle(null, 'Complete the Word')).difficulty,
        test: true,
      );
    } else if (puzzleName == 'Hangman') {
      puzzleWidget = Hangman(
        completePuzzle: completePuzzle,
        difficulty: (await TokiDatabase.instance.readPuzzle(null, 'Hangman')).difficulty,
        test: true,
      );
    } else if (puzzleName == 'Word Search') {
      puzzleWidget = WordSearchGame(
        completePuzzle: completePuzzle,
        difficulty: (await TokiDatabase.instance.readPuzzle(null, 'Word Search')).difficulty,
        test: true,
      );
    } else {
      throw Exception('Puzzle Name $puzzleName not found');
    }

    if (puzzleWidget != null) {
      Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (context) => PuzzleTemplate(
          puzzleWidget: puzzleWidget!,
          puzzleName: puzzleName,
          completePuzzle: completePuzzle,
          test: true,
        )
      ));
    } else {
      throw Exception('The puzzleWidget is null'); 
    }
  }

  static void startStopwatch() {
    stopwatch = Stopwatch();
    stopwatch!.start();
  }

  static int stopStopwatch() {
    stopwatch!.stop();
    return (stopwatch!.elapsed.inMilliseconds / 10).round();
  }

  static void addScoreToLeaderboard(String iOSLeaderboardID, int score) async {
    if (await GamesServices.isSignedIn) {
      GamesServices.submitScore(
        score: Score(
          iOSLeaderboardID: iOSLeaderboardID,
          value: score,
        )
      );
    }
  }

  static List<String> getWords() {
    return listOfWords;
  }
}

class PuzzleTemplate extends StatelessWidget {
  final Widget puzzleWidget;
  final Alarm? alarm;
  final String puzzleName;
  final Function completePuzzle;
  final bool test;
  const PuzzleTemplate({Key? key, required this.puzzleWidget, this.alarm, required this.puzzleName, required this.completePuzzle, required this.test}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: context.watch<Styles>().selectedAccentColor,
        body: SafeArea(
          child: Container(
            color: context.read<Styles>().backgroundColor,
            child: Column(
              children: [
                PageTitle(
                  title: puzzleName,
                ),
                EmergencyExitButton(
                  alarm: alarm, 
                  completePuzzle: completePuzzle,
                  test: test
                  ),
                Expanded(
                  child: Center(
                    child: puzzleWidget,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}