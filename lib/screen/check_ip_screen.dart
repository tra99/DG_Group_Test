import 'package:dg_group/service/network_info.dart';
import 'package:flutter/material.dart';

class CheckIpScreen extends StatefulWidget {
  const CheckIpScreen({super.key});
  @override
  State<CheckIpScreen> createState() => _CheckIpScreenState();
}

class _CheckIpScreenState extends State<CheckIpScreen> {
  final NetworkInfo _networkInfo = NetworkInfo();
  NetworkType _selectedType = NetworkType.wifi;
  String _ipv4 = 'Fetching…';
  String _ipv6 = 'Fetching…';
  bool _forceRefresh = false;

  @override
  void initState() {
    super.initState();
    _fetchIPs();
  }

  Future<void> _fetchIPs() async {
    setState(() {
      _ipv4 = 'Fetching…';
      _ipv6 = 'Fetching…';
    });
    final ipv4 = await _networkInfo.getIPv4(
      type: _selectedType,
      forceRefresh: _forceRefresh,
    );
    final ipv6 = await _networkInfo.getIPv6(
      type: _selectedType,
      forceRefresh: _forceRefresh,
    );
    setState(() {
      _ipv4 = ipv4;
      _ipv6 = ipv6;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Network Info')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: RadioListTile<NetworkType>(
                    title: const Text('Wi-Fi'),
                    value: NetworkType.wifi,
                    groupValue: _selectedType,
                    onChanged: (v) => setState(() => _selectedType = v!),
                    activeColor: Colors.orange,
                  ),
                ),
                Expanded(
                  child: RadioListTile<NetworkType>(
                    title: const Text('Mobile Data'),
                    value: NetworkType.mobile,
                    groupValue: _selectedType,
                    onChanged: (v) => setState(() => _selectedType = v!),
                    activeColor: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('IPv4: $_ipv4', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('IPv6: $_ipv6', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            InkWell(
              onTap: () => {
                _fetchIPs()
              },
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.orange,        
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.refresh, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Refresh',               
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}