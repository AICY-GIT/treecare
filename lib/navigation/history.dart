import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<Map<String, dynamic>> temp = [];
  void getInfo() {
    temp = [
      {
        'pic': 'assets/icons/logo.png',
        'name': 'TreeName1',
        'idTime': '13/8/2025',
        'added': true
      },
      {
        'pic': 'assets/icons/logo.png',
        'name': 'TreeName2',
        'idTime': '13/8/2025',
        'added': false
      },
      {
        'pic': 'assets/icons/logo.png',
        'name': 'TreeName2',
        'idTime': '13/8/2025',
        'added': false
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
                    // tap vao hien chi tiet
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
                                  fontSize: 27, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Identify at:',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              temp[index]['idTime'],
                              style: TextStyle(
                                  fontSize: 23, fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                        Spacer(),
                        IconButton(
                          iconSize: 32,
                          icon: Icon(
                            temp[index]['added']
                                ? Icons.add_circle_outline
                                : Icons.check_circle,
                          ),
                          onPressed: () {
                            setState(() {
                              if (temp[index]['added'] == true) {
                                temp[index]['added'] = false;
                              } else {
                                temp[index]['added'] = true;
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
