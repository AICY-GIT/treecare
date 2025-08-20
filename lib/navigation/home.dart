import 'package:flutter/material.dart';
import 'package:tree_care/features/plant_detail.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  List<Map<String, dynamic>> temp = [];
  void getInfo() {
    temp = [
      {
        'pic': 'assets/icons/logo.png',
        'name': 'TreeName1',
        'watering': '13/8/2025',
        'fertilize': '13/8/2025',
        'fav': true
      },
      {
        'pic': 'assets/icons/logo.png',
        'name': 'TreeName2',
        'watering': '13/8/2025',
        'fertilize': '13/8/2025',
        'fav': false
      },
      {
        'pic': 'assets/icons/logo.png',
        'name': 'TreeName3',
        'watering': '13/8/2025',
        'fertilize': '13/8/2025',
        'fav': true
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              height: 20,
            ),
            itemCount: temp.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    print('Clicked on ${temp[index]['name']}');
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const PlantDetailPage()));
                  },
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 195, 229, 244),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 5),
                              blurRadius: 5,
                              spreadRadius: 2)
                        ]),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(temp[index]['pic'])),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              temp[index]['name'],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Image.asset('assets/icons/water.png',
                                    width: 20, height: 20, fit: BoxFit.cover),
                                Text(
                                  temp[index]['watering'],
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset('assets/icons/fertilize.png',
                                    width: 20, height: 20, fit: BoxFit.cover),
                                Text(
                                  temp[index]['fertilize'],
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        IconButton(
                          iconSize: 32,
                          icon: Icon(
                            temp[index]['fav']
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: temp[index]['fav'] ? Colors.red : null,
                          ),
                          onPressed: () {
                            setState(() {
                              if (temp[index]['fav'] == true) {
                                temp[index]['fav'] = false;
                              } else {
                                temp[index]['fav'] = true;
                              }
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
