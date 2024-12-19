import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon/screens/details.dart';
import 'package:hackathon/screens/login_screen.dart';
import 'package:hackathon/screens/profile.dart';
import 'package:hackathon/services/llm.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;

  final List<String> _countries = [
    'USA',
    'India',
    'Canada',
    'UK',
    'Australia',
    'Germany',
    'France',
    'Japan',
    'China',
    'Brazil'
  ];

  final Map<String, List<String>> _states = {
    'USA': ['California', 'Texas', 'New York', 'Florida', 'Washington'],
    'India': [
      'Maharashtra',
      'Karnataka',
      'Tamil Nadu',
      'Uttar Pradesh',
      'Kerala'
    ],
    'Canada': ['Ontario', 'Quebec', 'British Columbia', 'Alberta', 'Manitoba'],
    'UK': [
      'England',
      'Scotland',
      'Wales',
      'Northern Ireland',
      'Greater London'
    ],
    'Australia': [
      'New South Wales',
      'Victoria',
      'Queensland',
      'Western Australia',
      'South Australia'
    ],
    'Germany': [
      'Bavaria',
      'North Rhine-Westphalia',
      'Baden-Württemberg',
      'Lower Saxony',
      'Hesse'
    ],
    'France': [
      'Île-de-France',
      'Occitanie',
      'Auvergne-Rhône-Alpes',
      'Provence-Alpes-Côte d\'Azur',
      'Hauts-de-France'
    ],
    'Japan': ['Tokyo', 'Osaka', 'Kanagawa', 'Aichi', 'Hokkaido'],
    'China': ['Guangdong', 'Jiangsu', 'Shandong', 'Zhejiang', 'Henan'],
    'Brazil': [
      'São Paulo',
      'Minas Gerais',
      'Rio de Janeiro',
      'Bahia',
      'Rio Grande do Sul'
    ]
  };
  Map<String, List<String>> _cities = {
    'California': [
      'Los Angeles',
      'San Francisco',
      'San Diego',
      'Sacramento',
      'San Jose'
    ],
    'Texas': ['Houston', 'Austin', 'Dallas', 'San Antonio', 'Fort Worth'],
    'New York': ['New York City', 'Buffalo', 'Rochester', 'Syracuse', 'Albany'],
    'Florida': ['Miami', 'Orlando', 'Tampa', 'Jacksonville', 'Tallahassee'],
    'Washington': ['Seattle', 'Spokane', 'Tacoma', 'Vancouver', 'Bellevue'],
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur', 'Thane', 'Nashik'],
    'Karnataka': ['Bangalore', 'Mysore', 'Hubli', 'Mangalore', 'Belagavi'],
    'Tamil Nadu': [
      'Chennai',
      'Coimbatore',
      'Madurai',
      'Tiruchirappalli',
      'Salem'
    ],
    'Uttar Pradesh': ['Lucknow', 'Kanpur', 'Agra', 'Varanasi', 'Allahabad'],
    'Kerala': [
      'Thiruvananthapuram',
      'Kochi',
      'Kozhikode',
      'Thrissur',
      'Kollam'
    ],
    'Ontario': ['Toronto', 'Ottawa', 'Mississauga', 'Hamilton', 'London'],
    'Quebec': ['Montreal', 'Quebec City', 'Laval', 'Gatineau', 'Longueuil'],
    'British Columbia': [
      'Vancouver',
      'Surrey',
      'Burnaby',
      'Victoria',
      'Abbotsford'
    ],
    'Alberta': ['Calgary', 'Edmonton', 'Red Deer', 'Lethbridge', 'St. Albert'],
    'Manitoba': [
      'Winnipeg',
      'Brandon',
      'Steinbach',
      'Portage la Prairie',
      'Thompson'
    ],
    'England': ['London', 'Birmingham', 'Manchester', 'Liverpool', 'Leeds'],
    'Scotland': ['Edinburgh', 'Glasgow', 'Aberdeen', 'Dundee', 'Inverness'],
    'Wales': ['Cardiff', 'Swansea', 'Newport', 'Bangor', 'St Davids'],
    'Northern Ireland': [
      'Belfast',
      'Derry',
      'Lisburn',
      'Newtownabbey',
      'Armagh'
    ],
    'Greater London': ['London'],
    'New South Wales': [
      'Sydney',
      'Newcastle',
      'Wollongong',
      'Central Coast',
      'Tamworth'
    ],
    'Victoria': ['Melbourne', 'Geelong', 'Ballarat', 'Bendigo', 'Shepparton'],
    'Queensland': [
      'Brisbane',
      'Gold Coast',
      'Townsville',
      'Cairns',
      'Toowoomba'
    ],
    'Western Australia': [
      'Perth',
      'Mandurah',
      'Bunbury',
      'Kalgoorlie',
      'Geraldton'
    ],
    'South Australia': [
      'Adelaide',
      'Mount Gambier',
      'Whyalla',
      'Murray Bridge',
      'Port Pirie'
    ],
    'Bavaria': ['Munich', 'Nuremberg', 'Augsburg', 'Regensburg', 'Ingolstadt'],
    'North Rhine-Westphalia': [
      'Cologne',
      'Düsseldorf',
      'Dortmund',
      'Essen',
      'Duisburg'
    ],
    'Baden-Württemberg': [
      'Stuttgart',
      'Karlsruhe',
      'Mannheim',
      'Freiburg',
      'Heidelberg'
    ],
    'Lower Saxony': [
      'Hanover',
      'Braunschweig',
      'Osnabrück',
      'Oldenburg',
      'Wolfsburg'
    ],
    'Hesse': ['Frankfurt', 'Wiesbaden', 'Kassel', 'Darmstadt', 'Offenbach'],
    'Île-de-France': [
      'Paris',
      'Boulogne-Billancourt',
      'Saint-Denis',
      'Argenteuil',
      'Versailles'
    ],
    'Occitanie': ['Toulouse', 'Montpellier', 'Nîmes', 'Perpignan', 'Béziers'],
    'Auvergne-Rhône-Alpes': [
      'Lyon',
      'Saint-Étienne',
      'Grenoble',
      'Villeurbanne',
      'Clermont-Ferrand'
    ],
    'Provence-Alpes-Côte d\'Azur': [
      'Marseille',
      'Nice',
      'Toulon',
      'Aix-en-Provence',
      'Avignon'
    ],
    'Hauts-de-France': ['Lille', 'Amiens', 'Roubaix', 'Tourcoing', 'Calais'],
    'Tokyo': ['Tokyo'],
    'Osaka': ['Osaka'],
    'Kanagawa': ['Yokohama'],
    'Aichi': ['Nagoya'],
    'Hokkaido': ['Sapporo'],
    'Guangdong': ['Guangzhou', 'Shenzhen', 'Dongguan', 'Foshan', 'Zhongshan'],
    'Jiangsu': ['Nanjing', 'Suzhou', 'Wuxi', 'Changzhou', 'Nantong'],
    'Shandong': ['Jinan', 'Qingdao', 'Zibo', 'Yantai', 'Weifang'],
    'Zhejiang': ['Hangzhou', 'Ningbo', 'Wenzhou', 'Jiaxing', 'Shaoxing'],
    'Henan': ['Zhengzhou', 'Luoyang', 'Nanyang', 'Kaifeng', 'Anyang'],
    'São Paulo': [
      'São Paulo',
      'Guarulhos',
      'Campinas',
      'São Bernardo do Campo',
      'Osasco'
    ],
    'Minas Gerais': [
      'Belo Horizonte',
      'Uberlândia',
      'Contagem',
      'Juiz de Fora',
      'Betim'
    ],
    'Rio de Janeiro': [
      'Rio de Janeiro',
      'São Gonçalo',
      'Duque de Caxias',
      'Nova Iguaçu',
      'Niterói'
    ],
    'Bahia': [
      'Salvador',
      'Feira de Santana',
      'Vitória da Conquista',
      'Camaçari',
      'Itabuna'
    ],
    'Rio Grande do Sul': [
      'Porto Alegre',
      'Caxias do Sul',
      'Pelotas',
      'Canoas',
      'Santa Maria'
    ],
  };

  void _updateLocation() async {
    if (_selectedCountry != null &&
        _selectedState != null &&
        _selectedCity != null) {
      try {
        String location = '$_selectedCity, $_selectedState, $_selectedCountry';
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({'location': location}, SetOptions(merge: true));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "Location updated!",
        )));
      } catch (e) {
        print("Error fetching location: $e");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "Error fetching location",
        )));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "Please fill all the fields",
      )));
    }
  }

  Stream<QuerySnapshot> getNGOContent() {
    return FirebaseFirestore.instance.collection('ngo_content').snapshots();
  }

  Stream<QuerySnapshot> getSafetyContent() {
    return FirebaseFirestore.instance.collection('safety_content').snapshots();
  }

  Stream<QuerySnapshot> getAwarenessContent() {
    return FirebaseFirestore.instance
        .collection('awareness_content')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        left: true,
        right: true,
        top: true,
        bottom: true,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Profile(),
                              ),
                            );
                          },
                          child: Center(
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'images/logo.png',
                            width: 30,
                            height: 30,
                          ),
                          Text(
                            "ReliefLink",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.chat,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.logout,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Help Us Locate You!",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              hintText: "Select Country",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            value: _selectedCountry,
                            items: _countries.map((country) {
                              return DropdownMenuItem(
                                value: country,
                                child: Text(
                                  country,
                                  style: TextStyle(color: Colors.blue),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCountry = value;
                                _selectedState =
                                    null; // Reset state when country changes
                                _selectedCity = null; // Reset city too
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          if (_selectedCountry != null)
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                hintText: "Select State",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              value: _selectedState,
                              items: (_states[_selectedCountry] ?? [])
                                  .map((state) {
                                return DropdownMenuItem(
                                  value: state,
                                  child: Text(
                                    state,
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedState = value;
                                  _selectedCity =
                                      null; // Reset city when state changes
                                });
                              },
                            ),
                          SizedBox(height: 10),
                          if (_selectedState != null)
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                hintText: "Select City",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              value: _selectedCity,
                              items:
                                  (_cities[_selectedState] ?? []).map((city) {
                                return DropdownMenuItem(
                                  value: city,
                                  child: Text(
                                    city,
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCity = value;
                                });
                              },
                            ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              _updateLocation();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "Click here to update location",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "NGO's Near You",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: getNGOContent(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(
                                  child: Text("No NGO content available."));
                            }
                            return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    children: snapshot.data!.docs.map((doc) {
                                  final data =
                                      doc.data() as Map<String, dynamic>;
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Details(
                                            collectionName: 'ngo_content',
                                            documentId: doc.id,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 200,
                                      height: 200,
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (data['imageURL'] != null)
                                            Image.network(data['imageURL'],
                                                height: 150,
                                                width: 150,
                                                fit: BoxFit.contain),
                                          SizedBox(height: 5),
                                          Text(
                                            data['title'] ?? '',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList()));
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Know your Safety Measures",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: getSafetyContent(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(
                                  child: Text("No Safety content available."));
                            }
                            return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    children: snapshot.data!.docs.map((doc) {
                                  final data =
                                      doc.data() as Map<String, dynamic>;
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Details(
                                                    collectionName:
                                                        'safety_content',
                                                    documentId: doc.id,
                                                  )),
                                        );
                                      },
                                      child: Container(
                                        width: 200,
                                        height: 200,
                                        margin: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if (data['imageURL'] != null)
                                              Image.network(data['imageURL'],
                                                  height: 150,
                                                  width: 150,
                                                  fit: BoxFit.contain),
                                            SizedBox(height: 5),
                                            Text(
                                              data['title'] ?? '',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ));
                                }).toList()));
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Know your Disaster Awareness",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: getAwarenessContent(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(
                                  child:
                                      Text("No Awareness content available."));
                            }
                            return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    children: snapshot.data!.docs.map((doc) {
                                  final data =
                                      doc.data() as Map<String, dynamic>;
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Details(
                                                  collectionName:
                                                      'awareness_content',
                                                  documentId: doc.id,
                                                )),
                                      );
                                    },
                                    child: Container(
                                      width: 200,
                                      height: 200,
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (data['imageURL'] != null)
                                            Image.network(data['imageURL'],
                                                height: 150,
                                                width: 150,
                                                fit: BoxFit.contain),
                                          SizedBox(height: 5),
                                          Text(
                                            data['title'] ?? '',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList()));
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 150,
                    height: 40,
                    decoration: BoxDecoration(color: Colors.black),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
