import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devu/user/searchpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Bookticket extends StatefulWidget {
  final String name;
  //const Bookticket({super.key});
  const Bookticket({super.key, required this.name});

  @override
  State<Bookticket> createState() => _BookticketState();
}

class _BookticketState extends State<Bookticket> {
  int selectedbuttonindex = 0;
  onbuttonpressed(int buttonindex) {
    setState(() {
      selectedbuttonindex = buttonindex;
    });
  }

  // storecollection(String servicedate) async {
  //   if (widget.id == 1) {
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .collection('ac_service')
  //         .doc(servicedate)
  //         .set({'status': "pending"});
  //   } else if (widget.id == 2) {
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .collection('oil_service')
  //         .doc(servicedate)
  //         .set({'status': "pending"});
  //   } else if (widget.id == 3) {
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .collection('wheel_service')
  //         .doc(servicedate)
  //         .set({'status': "pending"});
  //   } else if (widget.id == 4) {
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .collection('wash_service')
  //         .doc(servicedate)
  //         .set({'status': "pending"});
  //   }
  // }

  // storedetails() async {
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .update({
  //     'date': FieldValue.arrayUnion([storeddate]),
  //     'time': FieldValue.arrayUnion([time])
  //   });
  // }

  getpartners() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('partners').get();
    for (var doc in querySnapshot.docs) {
      String data = (doc.data() as Map<String, dynamic>)['companyname'];
      partners.add(data);
    }
  }

  String? data;
  String? idstad;
  getid() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('owners')
        .where('Stadium Name', isEqualTo: widget.name)
        .get();
    idstad = querySnapshot.docs[0].id;
    print('hello');
    print(idstad);
  }

  savedetails() async {
    // date = selectedDate.toString();
    // time = selectedTime.toString();
    // date = date!.substring(0, 10);
    // time = time!.substring(10, 15);
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    String nameuser = (snap.data() as Map<String, dynamic>)['username'];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('booking-data')
        .doc()
        .set({
      'date': storeddate,
      'time': time,
      'Stadium name': widget.name,
      'stadium-id': idstad,
      'user-id': FirebaseAuth.instance.currentUser!.uid,
      'status': 'pending',
      'user-name': nameuser
    });
    await FirebaseFirestore.instance
        .collection('owners')
        .doc(idstad)
        .collection('booking-data')
        .doc()
        .set({
      'user-id': FirebaseAuth.instance.currentUser!.uid,
      'date': storeddate,
      'time': time,
      'uid': idstad,
      'status': 'pending',
      'user-name': nameuser
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (ctx) => const SearchScreen()));
  }
  // storeBookticket(String datestored) async {
  //   DocumentSnapshot snap = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  //   List vehicle = (snap.data() as Map<String, dynamic>)['cars'];

  //   String name = (snap.data() as Map<String, dynamic>)['name'];
  //   String bookedservice='ac_service';
  //   if (widget.id == 1) {
  //     servicetype = 'ac-service';
  //     bookedservice = 'ac_service';
  //   }
  //   if (widget.id == 2) {
  //     servicetype = 'oil-service';
  //     bookedservice = 'oil_service';
  //   }
  //   if (widget.id == 3) {
  //     servicetype = 'wheel-alignment';
  //     bookedservice = 'wheel_service';
  //   }
  //   if (widget.id == 4) {
  //     servicetype = 'car-wash';
  //     bookedservice = 'wash_service';
  //   }
  //   DocumentSnapshot snap2 = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .collection(bookedservice)
  //       .doc(datestored)
  //       .get();
  //       String status=(snap2.data() as Map<String,dynamic>)['status'];
  //   await FirebaseFirestore.instance
  //       .collection('partners')
  //       .doc(data)
  //       .collection('Bookticket_data')
  //       .doc()
  //       .set({
  //     'user-name': name,
  //     'booked-date': storeddate,
  //     'time': time,
  //     'servicetype': servicetype,
  //     'vehicle': vehicle,
  //     'uid': FirebaseAuth.instance.currentUser!.uid,
  //     'user-status':status
  //   });
  // }

  searchpartid() async {
    final search = await FirebaseFirestore.instance
        .collection('partners')
        .where('companyname', isEqualTo: valuechoose)
        .get();
    data = (search.docs[0].data() as dynamic)['uid'];
  }

  getusername() async {}
  String? valuechoose;
  List<String> partners = [];
  @override
  void initState() {
    super.initState();
    getusername();
    getid();
  }

  // storepartner() async {
  //   await FirebaseFirestore.instance.collection('partners')
  //   .doc
  // }

  final DateTime _date = DateTime.now();
  Future<DateTime?> showDatePickerWithoutTime(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      // Discard the time component by setting the time to midnight (00:00:00)
      return DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    }

    return null;
  }

  String _currtext = 'Choose your date';
  String location = "";
  String address = "";

  String storeddate = "";
  String time = "";
  String servicetype = "ac service";

  getaddress() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      location = (snap.data() as Map<String, dynamic>)['address'];
    });
  }

  @override
  Widget build(BuildContext context) {
    location ??= "Please update address in My Profile";
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 19),

              //LOCATION FOR PICKUP CONTAINER
              // Container(
              //   height: 100,
              //   width: 500,
              //   decoration: BoxDecoration(
              //     color: const Color.fromARGB(255, 238, 224, 224),
              //     borderRadius: BorderRadius.circular(15),
              //   ),
              //   child: Column(
              //     children: [
              //       Text('Location for pickup',
              //           style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //               fontSize: 17,
              //               color: Colors.black)),
              //       const SizedBox(
              //         height: 15,
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Text(
              //           location,
              //           style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //               fontSize: 17,
              //               color: Colors.black),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              const SizedBox(height: 30),

              // DATE PICKER
              const Text(
                "Select your preferred date and time.",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              MaterialButton(
                onPressed: () async {
                  final DateTime? selectedDate =
                      await showDatePickerWithoutTime(context);
                  if (selectedDate != null) {
                    // Handle the selected date without the time component
                    print(selectedDate);
                  }
                  setState(() {
                    _currtext = selectedDate.toString();
                    _currtext = _currtext.substring(0, 10);
                    storeddate = _currtext;
                  });
                },
                color: Color.fromARGB(255, 9, 40, 67),
                child: Text(
                  _currtext,
                  style: const TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(
                height: 23,
              ),

              //PICK TIME SLOT
              const Text(
                "Pick Time Slot",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              const Divider(
                height: 60,
                color: Colors.black,
                thickness: 0.7,
              ),
              Row(
                children: const [
                  Icon(Icons.timer, color: Colors.red),
                  SizedBox(
                    width: 6,
                  ),

                  // AFTERNOON SLOTS
                  Text(
                    "Morning Slots",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(
                height: 17,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        onbuttonpressed(1);

                        setState(() {
                          time = "10-11AM";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: selectedbuttonindex == 1
                              ? Color.fromARGB(255, 9, 40, 67)
                              : Colors.white,
                          minimumSize: const Size(120, 40)),
                      child: Text(
                        "10-11AM",
                        style: TextStyle(
                            color: selectedbuttonindex == 1
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        onbuttonpressed(2);
                        setState(() {
                          time = "11-12PM";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedbuttonindex == 2
                            ? Color.fromARGB(255, 9, 40, 67)
                            : Colors.white,
                        minimumSize: const Size(120, 40),
                      ),
                      child: Text(
                        "11-12PM",
                        style: TextStyle(
                            color: selectedbuttonindex == 2
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        onbuttonpressed(3);
                        setState(() {
                          time = "12-1PM";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: selectedbuttonindex == 3
                              ? Color.fromARGB(255, 9, 40, 67)
                              : Colors.white,
                          minimumSize: const Size(120, 40)),
                      child: Text(
                        "12-1PM",
                        style: TextStyle(
                            color: selectedbuttonindex == 3
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
              const Divider(
                indent: 4,
                height: 75,
                color: Colors.black,
                thickness: 0.7,
              ),

              // EVENING SLOTS

              Row(
                children: const [
                  Icon(Icons.timer, color: Colors.red),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    "Evening Slots",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(
                height: 17,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        onbuttonpressed(4);
                        setState(() {
                          time = "2-3PM";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: selectedbuttonindex == 4
                              ? Color.fromARGB(255, 9, 40, 67)
                              : Colors.white,
                          minimumSize: const Size(120, 40)),
                      child: Text(
                        "2-3PM",
                        style: TextStyle(
                            color: selectedbuttonindex == 4
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        onbuttonpressed(5);
                        setState(() {
                          time = "3-4PM";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedbuttonindex == 5
                            ? Color.fromARGB(255, 9, 40, 67)
                            : Colors.white,
                        minimumSize: const Size(120, 40),
                      ),
                      child: Text(
                        "3-4PM",
                        style: TextStyle(
                            color: selectedbuttonindex == 5
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        onbuttonpressed(6);
                        setState(() {
                          time = "4-5PM";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: selectedbuttonindex == 6
                              ?Color.fromARGB(255, 9, 40, 67)
                              : Colors.white,
                          minimumSize: const Size(120, 40)),
                      child: Text(
                        "4-5PM",
                        style: TextStyle(
                            color: selectedbuttonindex == 6
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
              const Divider(
                indent: 4,
                height: 75,
                color: Colors.black,
                thickness: 0.7,
              ),

              // ORDER TEXT

              //Text(
              // "By placing an order, we will assign you a Mechanic and a Workshop to take care of your car problems.",
              //style: TextStyle(color: Colors.white,
              //     fontWeight: FontWeight.w500, fontSize: 15)),
              //const SizedBox(
              // height: 18,
              // ),
              Container(
                  height: 50,
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor:Color.fromARGB(255, 9, 40, 67) ),
                    onPressed: () {
                      String servicedate = "$storeddate,$time";

                      savedetails();
                      //storedetails();
                      // storecollection(servicedate);
                      // storeBookticket(servicedate);
                      // storepartner();
                      // Navigator.pushReplacement(
                      //     context,
                      //     PageTransition(
                      //         child: const Bottomnav(),
                      //         type: PageTransitionType.rightToLeftWithFade));
                    },
                    
                    child: const Text(
                      "Book now",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  )),
            ]),
          ),
        ),
      ),
    );
  }
}
