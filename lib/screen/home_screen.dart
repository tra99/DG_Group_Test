import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _weekdays = ['T1','T2','T3','T4','T5','T6','T7','CN','T2','T3'];
  final List<String> _dates    = ['08','09','10','11','12','13','14','15','16','17'];
  int _selectedIndex = 5;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
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

              const SizedBox(height: 16),
              SizedBox(
                height: 70,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: _weekdays.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final selected = i == _selectedIndex;
                    return Column(
                      children: [
                        Text(
                          _weekdays[i],
                          style: TextStyle(
                            fontSize: 12,
                            color: selected
                                ? Colors.black87
                                : Colors.grey[600],
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
                              color: selected
                                  ? const Color(0xFFE4B764)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                if (!selected)
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: const Offset(0,2),
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
                                    fontWeight: selected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: selected
                                        ? Colors.black87
                                        : Colors.grey[800],
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
              Container(
                margin: EdgeInsets.only(left: 6),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: const Offset(0,2),
                            )
                          ],
                        ),
                        padding: EdgeInsets.all(8),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.red,
                                ),
                                child: Row(
                                  children: [
                                    Text('LIVE',style: TextStyle(color: Colors.white,fontSize: 20),),
                                    Icon(Icons.live_tv_outlined,color: Colors.white,)
                                  ],
                                ),
                              ),
                              SizedBox(width: 6,),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(child: Text('6',style: TextStyle(color: Colors.white,fontSize: 20),)),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 6,),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: const Color.fromRGBO(228, 183, 100, 1)
                        ),
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Text('Giải đấu',style: TextStyle(color: Colors.black,fontSize: 20),),
                            Image.asset('asset/images/png/427321767.png',width: 80,)
                          ],
                        ),
                      ),
                      SizedBox(width: 6,),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.white
                        ),
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Text('Giải đấu',style: TextStyle(color: Colors.black,fontSize: 20),),
                            Image.asset('asset/images/png/42732177.png',width: 80,)
                          ],
                        ),
                      ),
                      SizedBox(width: 6,),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.white
                        ),
                        padding: EdgeInsets.all(16),
                        child: Icon(Icons.search)
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
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
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
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
                              Text(
                                'HÔM NAY',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'THÁNG 12',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
