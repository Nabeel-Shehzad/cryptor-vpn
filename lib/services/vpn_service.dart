import 'dart:async';
import 'package:flutter_vpn/flutter_vpn.dart';
import 'package:flutter_vpn/state.dart';
import 'package:network_info_plus/network_info_plus.dart';

class VpnService {
  static final VpnService _instance = VpnService._internal();
  factory VpnService() => _instance;
  VpnService._internal();

  final _networkInfo = NetworkInfo();
  Timer? _speedTimer;
  
  Stream<FlutterVpnState> get vpnStateStream => FlutterVpn.onStateChanged;
  
  Future<void> connectToVpn(String server, String username, String password) async {
    try {
      await FlutterVpn.prepare();
      await FlutterVpn.connect(
        server,
        username,
        password,
      );
    } catch (e) {
      print('VPN connection error: $e');
      rethrow;
    }
  }

  Future<void> disconnectVpn() async {
    try {
      await FlutterVpn.disconnect();
    } catch (e) {
      print('VPN disconnection error: $e');
      rethrow;
    }
  }

  Future<double> measurePing(String host) async {
    try {
      final startTime = DateTime.now();
      final result = await Process.run('ping', ['-c', '1', host]);
      final endTime = DateTime.now();
      return endTime.difference(startTime).inMilliseconds.toDouble();
    } catch (e) {
      print('Ping measurement error: $e');
      return 0.0;
    }
  }

  void startSpeedMeasurement(Function(double, double) onSpeedUpdate) {
    _speedTimer?.cancel();
    _speedTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      // This is a simplified speed measurement. In a real app, you'd want to
      // implement more accurate speed testing
      final downloadSpeed = await _measureSpeed(true);
      final uploadSpeed = await _measureSpeed(false);
      onSpeedUpdate(downloadSpeed, uploadSpeed);
    });
  }

  void stopSpeedMeasurement() {
    _speedTimer?.cancel();
    _speedTimer = null;
  }

  Future<double> _measureSpeed(bool isDownload) async {
    // This is a simplified implementation
    // In a real app, you'd want to implement actual speed testing
    try {
      // Simulate speed measurement
      return (DateTime.now().millisecondsSinceEpoch % 100).toDouble();
    } catch (e) {
      print('Speed measurement error: $e');
      return 0.0;
    }
  }
}
