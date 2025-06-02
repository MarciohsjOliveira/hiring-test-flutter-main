import 'package:flutter/material.dart';
import 'package:foxbit_hiring_test_template/src/presentation/home/view/home_view.dart';

/// Classe que centraliza as rotas da aplicação.
///
/// Facilita a manutenção, refatoração e navegação pelo app.
class AppRoutes {
  // Construtor privado para impedir instanciação
  AppRoutes._();

  /// Nome da rota inicial da aplicação.
  static const String home = '/';

  /// Mapa de rotas nomeadas da aplicação.
  ///
  /// Cada rota está associada a um WidgetBuilder que cria a tela correspondente.
  static final Map<String, WidgetBuilder> routes = {
    home: (BuildContext context) => const HomePage(),
  };
}
