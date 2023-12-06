import 'dart:ui';

import 'package:flame/components.dart';

import '../klondike_game.dart';
import '../models/pile.dart';
import '../models/suit.dart';
import 'card.dart';

class FoundationPile extends PositionComponent
    implements Pile {
  FoundationPile(int intSuit, {super.position})
      : suit = Suit.fromInt(intSuit),
        super(size: KlondikeGame.cardSize);

  final Suit suit;
  final List<Card> _cards = [];

  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = const Color(0x50ffffff);
  late final _suitPaint = Paint()
    ..color = suit.isRed
        ? const Color(0x3a000000)
        : const Color(0x64000000)
    ..blendMode = BlendMode.luminosity;

  @override
  bool canMoveCard(Card card) =>
      _cards.isNotEmpty && card == _cards.last;

  @override
  bool canAcceptCard(Card card) {
    final topCardRank =
        _cards.isEmpty ? 0 : _cards.last.rank.value;
    return card.suit == suit &&
        card.rank.value == topCardRank + 1;
  }

  @override
  void removeCard(Card card) {
    assert(canMoveCard(card));
    _cards.removeLast();
  }

  @override
  void returnCard(Card card) {
    card.position = position;
    card.priority = _cards.indexOf(card);
  }

  @override
  void acquireCard(Card card) {
    assert(card.isFaceUp);
    card.position = position;
    card.priority = _cards.length;
    _cards.add(card);
    card.pile = this;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(KlondikeGame.cardRRect, _borderPaint);
    suit.sprite.render(
      canvas,
      position: size / 2,
      anchor: Anchor.center,
      size: Vector2.all(KlondikeGame.cardWidth * 0.6),
      overridePaint: _suitPaint,
    );
  }
}
