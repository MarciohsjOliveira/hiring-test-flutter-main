class TradingInstrumentEntity {
  final int instrumentId;
  final String ticker;
  final String primaryProductSymbol;
  final String secondaryProductSymbol;
  final int indexOrder;

  const TradingInstrumentEntity({
    required this.instrumentId,
    required this.ticker,
    required this.primaryProductSymbol,
    required this.secondaryProductSymbol,
    required this.indexOrder,
  });
}
