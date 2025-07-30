import 'package:flutter_test/flutter_test.dart';
import 'package:phone_away/core/services/network_service.dart';

void main() {
  group('NetworkService Tests', () {
    late NetworkService networkService;

    setUp(() {
      networkService = NetworkService();
    });

    group('Singleton Pattern', () {
      test('returns same instance when called multiple times', () {
        final instance1 = NetworkService();
        final instance2 = NetworkService();

        expect(instance1, equals(instance2));
      });
    });

    group('Network Exceptions', () {
      test('NetworkException has correct message', () {
        const message = 'Test network error';
        final exception = NetworkException(message);

        expect(exception.message, equals(message));
        expect(exception.toString(), equals(message));
      });

      test('NetworkTimeoutException extends NetworkException', () {
        const message = 'Request timeout';
        final exception = NetworkTimeoutException(message);

        expect(exception, isA<NetworkException>());
        expect(exception.message, equals(message));
        expect(exception.toString(), equals(message));
      });

      test('NetworkConnectionException extends NetworkException', () {
        const message = 'Connection failed';
        final exception = NetworkConnectionException(message);

        expect(exception, isA<NetworkException>());
        expect(exception.message, equals(message));
        expect(exception.toString(), equals(message));
      });
    });

    group('Connection Status Stream', () {
      test('connectionStatusStream returns a stream', () {
        final stream = networkService.connectionStatusStream;

        expect(stream, isA<Stream<bool>>());
      });

      test('stream is broadcast stream', () {
        final stream = networkService.connectionStatusStream;

        expect(stream.isBroadcast, isTrue);
      });

      test('multiple listeners can subscribe to stream', () {
        final stream = networkService.connectionStatusStream;

        // Should be able to listen multiple times without error
        expect(() {
          stream.listen((status) {});
          stream.listen((status) {});
        }, returnsNormally);
      });
    });

    group('Service Initialization', () {
      test('service can be instantiated', () {
        expect(networkService, isA<NetworkService>());
      });

      test('service has connection status stream', () {
        expect(networkService.connectionStatusStream, isNotNull);
      });
    });

    group('Error Handling', () {
      test('network exceptions can be thrown and caught', () {
        expect(
          () => throw NetworkException('Test error'),
          throwsA(isA<NetworkException>()),
        );
      });

      test('timeout exceptions can be thrown and caught', () {
        expect(
          () => throw NetworkTimeoutException('Timeout error'),
          throwsA(isA<NetworkTimeoutException>()),
        );
      });

      test('connection exceptions can be thrown and caught', () {
        expect(
          () => throw NetworkConnectionException('Connection error'),
          throwsA(isA<NetworkConnectionException>()),
        );
      });
    });
  });
}
