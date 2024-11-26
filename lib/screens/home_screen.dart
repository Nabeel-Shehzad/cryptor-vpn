import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/vpn_service.dart';
import '../models/vpn_location.dart';
import 'package:flutter_vpn/flutter_vpn.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final VpnService _vpnService = VpnService();
  double _downloadSpeed = 0.0;
  double _uploadSpeed = 0.0;
  double _ping = 0.0;
  VpnLocation? _selectedLocation;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _vpnService.vpnStateStream.listen((state) {
      setState(() {
        _isConnected = state == FlutterVpnState.connected;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildConnectionStatus(),
            _buildSpeedMetrics(),
            _buildLocationSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Image.asset('assets/logo.png', height: 40),
          const SizedBox(width: 10),
          const Text(
            'Cryptor VPN',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return GestureDetector(
      onTap: _toggleVpnConnection,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isConnected ? Colors.green : Colors.red,
          boxShadow: [
            BoxShadow(
              color: (_isConnected ? Colors.green : Colors.red).withOpacity(0.3),
              spreadRadius: 10,
              blurRadius: 20,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            _isConnected ? Icons.power_settings_new : Icons.power_off,
            size: 80,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSpeedMetrics() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetricCard('Download', '$_downloadSpeed MB/s', Icons.download),
          _buildMetricCard('Upload', '$_uploadSpeed MB/s', Icons.upload),
          _buildMetricCard('Ping', '${_ping.toStringAsFixed(0)} ms', Icons.speed),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSelector() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListView.builder(
          itemCount: _mockLocations.length,
          itemBuilder: (context, index) {
            final location = _mockLocations[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(location.flag),
              ),
              title: Text(
                location.country,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                location.city,
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: Text(
                '${location.ping} ms',
                style: const TextStyle(color: Colors.grey),
              ),
              onTap: () => _selectLocation(location),
            );
          },
        ),
      ),
    );
  }

  void _toggleVpnConnection() async {
    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location first')),
      );
      return;
    }

    if (_isConnected) {
      await _vpnService.disconnectVpn();
      _vpnService.stopSpeedMeasurement();
    } else {
      await _vpnService.connectToVpn(
        _selectedLocation!.serverAddress,
        'username', // In a real app, these would be proper credentials
        'password',
      );
      _vpnService.startSpeedMeasurement((download, upload) {
        setState(() {
          _downloadSpeed = download;
          _uploadSpeed = upload;
        });
      });
    }
  }

  void _selectLocation(VpnLocation location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  // Mock data - In a real app, this would come from an API
  final List<VpnLocation> _mockLocations = [
    VpnLocation(
      id: '1',
      country: 'United States',
      city: 'New York',
      flag: 'https://flagcdn.com/w80/us.png',
      serverAddress: 'us.vpn.example.com',
      latitude: 40.7128,
      longitude: -74.0060,
      ping: 45,
    ),
    VpnLocation(
      id: '2',
      country: 'United Kingdom',
      city: 'London',
      flag: 'https://flagcdn.com/w80/gb.png',
      serverAddress: 'uk.vpn.example.com',
      latitude: 51.5074,
      longitude: -0.1278,
      ping: 65,
    ),
    VpnLocation(
      id: '3',
      country: 'Japan',
      city: 'Tokyo',
      flag: 'https://flagcdn.com/w80/jp.png',
      serverAddress: 'jp.vpn.example.com',
      latitude: 35.6762,
      longitude: 139.6503,
      ping: 85,
    ),
  ];
}
