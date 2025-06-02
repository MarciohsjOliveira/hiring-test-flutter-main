import 'package:foxbit_hiring_test_template/src/domain/entities/trading_instrument_entity.dart';

class TradingInstrumentModel extends TradingInstrumentEntity {
  TradingInstrumentModel({
    required super.instrumentId,
    required super.ticker,
    required super.primaryProductSymbol,
    required super.secondaryProductSymbol,
    required super.indexOrder,
  });

  factory TradingInstrumentModel.fromJson(Map<String, dynamic> json) {
    return TradingInstrumentModel(
      instrumentId: json['InstrumentId'] as int,
      ticker: json['Symbol'] as String,
      primaryProductSymbol: json['Product1Symbol'] as String,
      secondaryProductSymbol: json['Product2Symbol'] as String,
      indexOrder: json['SortIndex'] as int,
    );
  }
}
