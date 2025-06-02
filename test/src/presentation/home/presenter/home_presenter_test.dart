import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/src/core/networking/foxbit_web_socket.dart.dart';
import 'package:foxbit_hiring_test_template/src/data/data.dart';
import 'package:foxbit_hiring_test_template/src/domain/domain.dart';
import 'package:foxbit_hiring_test_template/src/presentation/home/presenter/home_presenter.dart';

class FakeHeartBeatUseCase extends HeartbeatUseCase {
  FakeHeartBeatUseCase() : super(HeartbeatRepository());


  @override
  void execute(Observer<void> observer, [FoxbitWebSocket? params]) {
    // Simula chamada direta do onComplete após execução
    Future.microtask(() => observer.onComplete());
  }

}

void main() {
  late HomePresenter presenter;
  late FakeHeartBeatUseCase fakeUseCase;

  setUp(() {
    fakeUseCase = FakeHeartBeatUseCase();
    presenter = HomePresenterTestable(fakeUseCase);
  });

  test('Deve chamar heartbeatOnComplete quando o heartbeat for concluído', () async {
    var callbackChamado = false;

    presenter.heartbeatOnComplete = () {
      callbackChamado = true;
    };
    presenter.heartbeatOnError = (_) {
      fail('Não deveria ter chamado onError');
    };

    presenter.sendHeartbeat(FakeWebSocket() as FoxbitWebSocket);

    await Future.delayed(Duration.zero);

    expect(callbackChamado, isTrue, reason: 'O callback heartbeatOnComplete deveria ter sido chamado.');
  });
}

/// Fake WebSocket só para passar como parâmetro
class FakeWebSocket extends FoxbitWebSocket {}

/// HomePresenter com injeção do usecase fake
class HomePresenterTestable extends HomePresenter {
  final HeartbeatUseCase _fakeUseCase;

  HomePresenterTestable(this._fakeUseCase);

  @override
  void sendHeartbeat(FoxbitWebSocket ws) {
    _fakeUseCase.execute(_TestHeartBeatObserver(this), ws);
  }
}

/// Observer implementation for testing heartbeat
class _TestHeartBeatObserver extends Observer<void> {
  final HomePresenter presenter;

  _TestHeartBeatObserver(this.presenter);

  @override
  void onComplete() {
    presenter.heartbeatOnComplete.call();
  }

  @override
  void onError(e) {
    presenter.heartbeatOnError.call(e);
  }

  @override
  void onNext(void _) {}
}
