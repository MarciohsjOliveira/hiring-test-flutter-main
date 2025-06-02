
import 'package:foxbit_hiring_test_template/src/domain/entities/entities.dart';

/// Representa um ativo de criptomoeda, combinando dados de instrumento
/// (ex: símbolo, par de negociação) com dados de cotação (ex: preço, volume).
class CryptoAssetEntity {
  /// Detalhes do instrumento de negociação (ex: par BTC/USDT).
  final TradingInstrumentEntity instrumentDetails;

  /// Cotação mais recente associada ao instrumento.
  final MarketQuoteEntity? latestQuote;

  /// Cria um [CryptoAssetEntity] com os detalhes do instrumento e uma cotação opcional.
  CryptoAssetEntity({
    required this.instrumentDetails,
    this.latestQuote,
  });

  /// Nome do produto principal (ex: BTC).
  String get mainProductName => instrumentDetails.primaryProductSymbol;

  /// Nome do par de negociação (ex: USDT).
  String get tradingPair => instrumentDetails.secondaryProductSymbol;

  /// Identificador único do instrumento.
  int get instrumentId => instrumentDetails.instrumentId;

  /// Último preço negociado, ou "0.0" se não houver cotação.
  String get currentPrice => latestQuote?.latestPrice ?? '0.0';

  /// Volume de negociação nas últimas 24h, ou 0.0 se não disponível.
  double get tradedVolume24h => latestQuote?.volume24hRolling ?? 0.0;

  /// Variação percentual do preço nas últimas 24h, ou 0.0 se não disponível.
  double get priceVariation24h => latestQuote?.priceChange24hRolling ?? 0.0;

  /// Retorna uma nova instância com uma nova cotação, mantendo os dados do instrumento.
  CryptoAssetEntity copyWithNewQuote(MarketQuoteEntity quote) {
    return CryptoAssetEntity(
      instrumentDetails: instrumentDetails,
      latestQuote: quote,
    );
  }
}
