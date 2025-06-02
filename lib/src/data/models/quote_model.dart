import 'package:foxbit_hiring_test_template/src/domain/entities/market_quote_entity.dart';

class QuoteModel extends MarketQuoteEntity {
  QuoteModel({
    required super.instrumentId,
    required super.latestPrice,
    required super.volume24hRolling,
    required super.priceChange24hRolling,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      instrumentId: json['InstrumentId'] as int,
      latestPrice: json['LastTradedPx'] as String,
      volume24hRolling: (json['Rolling24HrVolume'] as num).toDouble(),
      priceChange24hRolling: (json['Rolling24HrPxChange'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'InstrumentId': instrumentId,
      'LastTradedPx': latestPrice,
      'Rolling24HrVolume': volume24hRolling,
      'Rolling24HrPxChange': priceChange24hRolling,
    };
  }
}
