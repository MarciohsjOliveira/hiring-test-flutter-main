class MarketQuoteEntity {
  final int instrumentId;
  final String latestPrice;
  final double volume24hRolling;
  final double priceChange24hRolling;

  const MarketQuoteEntity({
    required this.instrumentId,
    required this.latestPrice,
    required this.volume24hRolling,
    required this.priceChange24hRolling, 
  });
}
