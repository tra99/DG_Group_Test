import 'package:dg_group/screen/check_ip_screen.dart';
import 'package:flutter/material.dart';
import 'video_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _weekdays = ['T2','T3','T4','T5','T6','T7','CN','T2','T3'];
  final List<String> _dates    = ['09','10','11','12','13','14','15','16','17'];
  int _selectedIndex = 4;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    'asset/images/png/121111205d224a6e8fced43a48e12a2c863bfa37.png',
                    width: double.infinity,
                    height: w * .2,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 4,
                    left: (w - w * .7) / 2,
                    child: Container(
                      width: w * .7,
                      height: w * .17,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(w * .1),
                          topRight: Radius.circular(w * .1),
                        ),
                        color: const Color.fromRGBO(228, 183, 100, 1),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "LỊCH THI ĐẤU",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: w * .06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: w * .03,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14),
                        ),
                        color: const Color.fromRGBO(228, 183, 100, 1),
                      ),
                    ),
                  ),
                ],
              ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    SizedBox(
                      height: 70,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: _weekdays.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, i) {
                          final bool selected = i == _selectedIndex;
                          return Column(
                            children: [
                              Text(
                                    _weekdays[i],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: selected ? Colors.black87 : Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                              GestureDetector(
                                onTap: () => setState(() => _selectedIndex = i),
                                child: Container(
                                  width: 60,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: selected ? const Color(0xFFE4B764) : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      if (!selected)
                                        const BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        )
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      
                                      Text(
                                        _dates[i],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                                          color: selected ? Colors.black87 : Colors.grey[800],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      if (selected)
                                        Container(
                                          height: 3,
                                          width: 24,
                                          decoration: BoxDecoration(
                                            color: Colors.black87,
                                            borderRadius: BorderRadius.circular(1.5),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),
                    SizedBox(
                      height: 48,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white
                              ,borderRadius: BorderRadius.circular(6),
                              
                            ),
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.live_tv_outlined, size: 16, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text('LIVE',
                                      style: TextStyle(
                                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                ],
                              ),
                            ),
                            
                            const SizedBox(width: 12),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: const Text('6',
                                  style: TextStyle(
                                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3C05E),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.emoji_events, size: 16, color: Colors.black87),
                                SizedBox(width: 6),
                                Text('GIẢI ĐẤU',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)),
                              ],
                            ),
                          ),

                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.schedule, size: 16, color: Colors.black54),
                                SizedBox(width: 6),
                                Text('THỜI GIAN',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12)),
                              ],
                            ),
                          ),

                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                              ],
                            ),
                            child: const Icon(Icons.search, size: 20, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        width: double.infinity,
                        height: w * 0.14,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromRGBO(228, 183, 100, 1),
                              Color.fromRGBO(243, 192, 94, 1),
                            ],
                          ),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                          ],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(w * 0.08),
                            topRight: Radius.circular(w * 0.08),
                          ),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Image.asset(
                                'asset/images/png/Vector.png',
                                width: w * 0.12,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Marble Magic P8',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: w * 0.05,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Row(
                                children: const [
                                  Text('HÔM NAY', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                  SizedBox(width: 8),
                                  Text('THÁNG 12', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: const VideoThumbnailList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:  Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckIpScreen()))
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.orange,        
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.task_alt_outlined, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Task 2',               
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }
}