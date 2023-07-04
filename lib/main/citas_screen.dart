import 'package:cuts/main/citas_system/citasPendientes_screen.dart';
import 'package:cuts/main/citas_system/citasTerminadas_screen.dart';
import 'package:cuts/widgets/bubble_tab_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CitasPage extends StatefulWidget {
  const CitasPage({super.key});

  @override
  State<CitasPage> createState() => _CitasPageState();
}

class _CitasPageState extends State<CitasPage>
    with SingleTickerProviderStateMixin {
  final List<Tab> tabs = <Tab>[
    Tab(text: "Pendientes"),
    Tab(text: "Terminadas"),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      /*controller.animateToPage(index,
          duration: Duration(seconds: 1), curve: Curves.linear);*/
    });
  }

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final _pages = [CitasPendientesPage(), CitasTerminadasPage()];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: screenSize / 8,
            child: Container(
                color: Colors.black,
                child: Column(
                  children: [
                    Text('Citas',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: screenSize.width * 0.05,
                            fontWeight: FontWeight.bold)),
                    Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        child: Theme(
                            data: ThemeData(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                            ),
                            child: TabBar(
                              controller: _tabController,
                              onTap: _onItemTapped,
                              overlayColor:
                                  MaterialStateProperty.resolveWith((states) {
                                // If the button is pressed, return green, otherwise blue
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.transparent;
                                }
                                return Colors.transparent;
                              }),
                              indicatorSize: TabBarIndicatorSize.label,
                              indicatorColor: Colors.transparent,
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.grey[600],
                              indicator: BubbleTabIndicator(
                                indicatorHeight: 25.0,
                                indicatorColor: Colors.white,
                                padding: EdgeInsets.all(10),
                                tabBarIndicatorSize: TabBarIndicatorSize.label,
                              ),
                              tabs: tabs,
                            )))
                  ],
                ))),
        body: _pages[_selectedIndex]);
  }
}
