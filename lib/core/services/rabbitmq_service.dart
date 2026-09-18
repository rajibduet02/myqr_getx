import 'package:dart_amqp/dart_amqp.dart';
import 'package:get/get.dart';

class RabbitMqService extends GetxService {
  Future<RabbitMqService> init() async {
    _initiateConsumer();
    return this;
  }

  Future<void> _initiateConsumer() async {
    try {
      final settings = ConnectionSettings(
        host: '192.168.0.104:5672',
        authProvider: PlainAuthenticator('guest', 'guest'),
      );
      final client = Client(settings: settings);
      final channel = await client.channel();
      final queue = await channel.queue(
        'demo-queue',
        durable: true,
        exclusive: false,
        autoDelete: false,
      );
      final consumer = await queue.consume();
      consumer.listen((AmqpMessage message) {
        print(' [x] Received string: ${message.payloadAsString}');
        print(' [x] Received json: ${message.payloadAsJson}');
        print(' [x] Received raw: ${message.payload}');
        message.reply('world');
      });
    } catch (e) {
      print('RabbitMQ connection failed: $e');
    }
  }
}
