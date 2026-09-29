import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bot_player.dart';
import 'game_logic.dart';
import 'multiplayer_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const BlackQueenApp());
}

class BlackQueenApp extends StatelessWidget {
  const BlackQueenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Black Queen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD7AA45),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}

String seatName(int seat) => seat == 0 ? 'You' : 'Bot $seat';

class CardView extends StatelessWidget {
  final PlayingCard card;
  final bool dimmed;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const CardView({
    super.key,
    required this.card,
    this.dimmed = false,
    this.onTap,
    this.width = 62,
    this.height = 88,
  });

  @override
  Widget build(BuildContext context) {
    final red =
        card.suit == Suit.hearts || card.suit == Suit.diamonds;
    final queen = card.isBlackQueen;
    final ink = red ? const Color(0xFFB71C1C) : const Color(0xFF161616);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 140),
        opacity: dimmed ? .30 : 1,
        child: Container(
          width: width,
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFEFA),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: queen ? const Color(0xFFD4A72C) : const Color(0xFFB8B8B8),
              width: queen ? 2.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.42),
                blurRadius: 6,
                offset: const Offset(1, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 4,
                left: 5,
                child: _CardCorner(
                  rank: card.rankLabel,
                  suit: card.suitSymbol,
                  color: ink,
                ),
              ),
              Positioned(
                bottom: 4,
                right: 5,
                child: Transform.rotate(
                  angle: 3.1415926,
                  child: _CardCorner(
                    rank: card.rankLabel,
                    suit: card.suitSymbol,
                    color: ink,
                  ),
                ),
              ),
              Center(
                child: Text(
                  card.suitSymbol,
                  style: TextStyle(
                    color: ink,
                    fontSize: width < 50 ? 24 : 34,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (queen)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 16,
                  child: Text(
                    'BLACK QUEEN',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFFB8860B),
                      fontSize: width < 50 ? 5 : 6,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .5,
                    ),
                  ),
                ),
            ],
          ),
        ),
      )
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF06140D), Color(0xFF0C3524), Color(0xFF06140D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF101F18),
                          border: Border.all(
                            color: const Color(0xFFD7AA45),
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Q♠',
                            style: TextStyle(
                              color: Color(0xFFE4C36A),
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'BLACK QUEEN',
                        style: TextStyle(
                          fontSize: 29,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'CLASSIC CARD GAME',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _MenuButton(
                          icon: Icons.smart_toy_rounded,
                          title: '1 PLAYER',
                          subtitle: 'Play against computer',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GamePage(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _MenuButton(
                          icon: Icons.people_alt_rounded,
                          title: 'MULTIPLAYER',
                          subtitle: 'Host or join with friends',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MultiplayerMenuPage(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _MenuButton(
                          icon: Icons.emoji_events_rounded,
                          title: 'SCOREBOARD',
                          subtitle: 'View all four player scores',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ScoreboardPage(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF102A1E),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFD7AA45).withOpacity(.13),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFFE4C36A),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.white38),
            ],
          ),
        ),
      ),
    );
  }
}

class MultiplayerMenuPage extends StatelessWidget {
  const MultiplayerMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MULTIPLAYER'),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF06140D), Color(0xFF0C3524)],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Row(
              children: [
                Expanded(
                  child: _ModeCard(
                    icon: Icons.wifi_tethering_rounded,
                    title: 'HOST GAME',
                    subtitle: 'Create a room',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HostLobbyPage(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _ModeCard(
                    icon: Icons.login_rounded,
                    title: 'JOIN GAME',
                    subtitle: 'Play with friends',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const JoinPage(),
                      ),
                    ),
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

class _ModeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF102A1E),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: const Color(0xFFE4C36A), size: 40),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScoreboardPage extends StatelessWidget {
  const ScoreboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SCOREBOARD'),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF06140D), Color(0xFF0C3524)],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '4 PLAYER SCOREBOARD',
                  style: TextStyle(
                    color: Color(0xFFE4C36A),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 14),
                for (int i = 0; i < 4; i++)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF102A1E),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${i + 1}',
                          style: const TextStyle(
                            color: Color(0xFFE4C36A),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            _GameScoreMemory.names[i],
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          '${_GameScoreMemory.scores[i]}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Text(
                  'Lowest score wins',
                  style: TextStyle(color: Colors.white54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GameScoreMemory {
  static final scores = [0, 0, 0, 0];
  static final names = ['You', 'Bot 1', 'Bot 2', 'Bot 3'];
}

,
    );
  }
}

class _CardCorner extends StatelessWidget {
  final String rank;
  final String suit;
  final Color color;

  const _CardCorner({
    required this.rank,
    required this.suit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          rank,
          style: TextStyle(
            color: color,
            fontSize: 14,
            height: .9,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          suit,
          style: TextStyle(
            color: color,
            fontSize: 11,
            height: .9,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class CardBack extends StatelessWidget {
  final double width;
  final double height;

  const CardBack({
    super.key,
    this.width = 48,
    this.height = 68,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE4C56A), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.35),
            blurRadius: 5,
            offset: const Offset(1, 2),
          ),
        ],
        gradient: const LinearGradient(
          colors: [Color(0xFF193E75), Color(0xFF071C3C)],
        ),
      ),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color(0xFFE4C56A)),
          ),
          child: const Center(
            child: Text(
              '♠',
              style: TextStyle(
                color: Color(0xFFE4C56A),
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PlayerBadge extends StatelessWidget {
  final String name;
  final int score;
  final bool active;
  final bool you;

  const PlayerBadge({
    super.key,
    required this.name,
    required this.score,
    required this.active,
    this.you = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFD7AA45) : const Color(0xFF123022),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: active ? const Color(0xFFFFE6A0) : Colors.white.withOpacity(.10),
        ),
        boxShadow: active
            ? [
                BoxShadow(
                  color: const Color(0xFFD7AA45).withOpacity(.30),
                  blurRadius: 14,
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            you ? Icons.person_rounded : Icons.person_outline_rounded,
            size: 17,
            color: active ? Colors.black87 : Colors.white70,
          ),
          const SizedBox(width: 5),
          Text(
            name,
            style: TextStyle(
              color: active ? Colors.black87 : Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$score',
            style: TextStyle(
              color: active ? Colors.black87 : const Color(0xFFE7C66E),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final BlackQueenGame game = BlackQueenGame();
  final BotPlayer bot = BotPlayer(level: BotLevel.hard);

  List<PlayedCard> table = [];
  String message = '';
  bool busy = false;

  @override
  void initState() {
    super.initState();
    _startDeal();
  }

  Future<void> _startDeal() async {
    busy = true;
    setState(() {
      game.startDeal();
      table = [];
      message = '';
    });
    await _botsPlay();
    if (mounted) setState(() => busy = false);
  }

  Future<void> _botsPlay() async {
    while (mounted && !game.dealOver && game.currentSeat != 0) {
      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      final seat = game.currentSeat;
      await _play(seat, bot.chooseCard(game, seat));
    }
  }

  Future<void> _play(int seat, PlayingCard card) async {
    final error = game.playCard(seat, card);
    if (error != null) {
      if (mounted) setState(() => message = error);
      return;
    }

    if (game.trick.isNotEmpty) {
      if (mounted) {
        setState(() {
          table = List.of(game.trick);
          message = '';
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        table = List.of(game.lastTrick);
        message = '${seatName(game.lastTrickWinner!)} won the round  •  +${game.lastTrickPoints} points';
      });
    }

    await Future.delayed(const Duration(milliseconds: 1300));
    if (!mounted) return;
    setState(() {
      table = [];
      message = game.dealOver ? 'Deal finished!' : '';
    });
  }

  Future<void> _onTapCard(PlayingCard card) async {
    if (busy || game.currentSeat != 0 || game.dealOver) return;
    busy = true;
    await _play(0, card);
    await _botsPlay();
    if (mounted) setState(() => busy = false);
  }

  Widget _tableCard(int seat, double width, double height) {
    final cards = table.where((p) => p.seat == seat).toList();
    if (cards.isEmpty) return SizedBox(width: width, height: height);
    return CardView(card: cards.first.card, width: width, height: height);
  }

  @override
  Widget build(BuildContext context) {
    final canPlay = !busy && game.currentSeat == 0 && !game.dealOver;
    final legal = canPlay ? game.legalMoves(0) : <PlayingCard>[];
    final size = MediaQuery.of(context).size;
    final cardWidth = (size.width / 17).clamp(43.0, 60.0);
    final cardHeight = cardWidth * 1.42;

    String status;
    if (game.dealOver) {
      status = 'DEAL FINISHED';
    } else if (canPlay) {
      status = 'YOUR TURN • PLAY A CARD';
    } else {
      status = '${seatName(game.currentSeat).toUpperCase()} IS PLAYING...';
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF06150E), Color(0xFF0A2B1D), Color(0xFF071B12)],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(child: CustomPaint(painter: TablePatternPainter())),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 7, 14, 4),
                    child: Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: Color(0xFFE2BD5B), size: 19),
                        const SizedBox(width: 7),
                        const Text(
                          'BLACK QUEEN',
                          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 2),
                        ),
                        const Spacer(),
                        Text('DEAL ${game.dealNumber}', style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Center(
                            child: Container(
                              width: size.width * .53,
                              height: size.height * .55,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0C3423).withOpacity(.80),
                                borderRadius: BorderRadius.circular(35),
                                border: Border.all(color: const Color(0xFFD7AA45).withOpacity(.18), width: 1.5),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(.30), blurRadius: 30, spreadRadius: 5)],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 2,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: PlayerBadge(name: 'Bot 1', score: game.scores[1], active: game.currentSeat == 1 && !game.dealOver),
                          ),
                        ),
                        Positioned(
                          left: 7,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: PlayerBadge(name: 'Bot 2', score: game.scores[2], active: game.currentSeat == 2 && !game.dealOver),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 7,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: PlayerBadge(name: 'Bot 3', score: game.scores[3], active: game.currentSeat == 3 && !game.dealOver),
                            ),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            width: size.width * .40,
                            height: size.height * .45,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned(top: 0, child: _tableCard(1, cardWidth, cardHeight)),
                                Positioned(left: 0, child: _tableCard(2, cardWidth, cardHeight)),
                                Positioned(right: 0, child: _tableCard(3, cardWidth, cardHeight)),
                                Positioned(bottom: 0, child: _tableCard(0, cardWidth, cardHeight)),
                                if (table.isEmpty && !game.dealOver)
                                  const Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.style_rounded, size: 31, color: Colors.white12),
                                      SizedBox(height: 4),
                                      Text('PLAY AREA', style: TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          right: 12,
                          top: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                            decoration: BoxDecoration(color: Colors.black.withOpacity(.18), borderRadius: BorderRadius.circular(15)),
                            child: const Text('LOWEST SCORE WINS  •  ♠Q = 12  •  ♥ = 1', style: TextStyle(color: Colors.white54, fontSize: 8, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: cardHeight + 49,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                              decoration: BoxDecoration(
                                color: canPlay ? const Color(0xFFD7AA45).withOpacity(.16) : Colors.black.withOpacity(.18),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: canPlay ? const Color(0xFFD7AA45).withOpacity(.45) : Colors.white12),
                              ),
                              child: Text(message.isNotEmpty ? message : status, style: TextStyle(color: canPlay ? const Color(0xFFF2D483) : Colors.white70, fontSize: 11, fontWeight: FontWeight.w800)),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: cardHeight + 15,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: PlayerBadge(name: 'You', score: game.scores[0], active: canPlay && !game.dealOver, you: true),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: SizedBox(
                            height: cardHeight + 7,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              itemCount: game.hands[0].length,
                              itemBuilder: (context, index) {
                                final card = game.hands[0][index];
                                return CardView(
                                  card: card,
                                  width: cardWidth,
                                  height: cardHeight,
                                  dimmed: canPlay && !legal.contains(card),
                                  onTap: () => _onTapCard(card),
                                );
                              },
                            ),
                          ),
                        ),
                        if (game.dealOver && !busy)
                          Positioned(
                            right: 15,
                            bottom: 5,
                            child: FilledButton.icon(
                              onPressed: _startDeal,
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              label: const Text('NEXT DEAL'),
                              style: FilledButton.styleFrom(backgroundColor: const Color(0xFFD7AA45), foregroundColor: Colors.black87),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TablePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(.012)..strokeWidth = 1;
    for (double x = -size.height; x < size.width; x += 38) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
