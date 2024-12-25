import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon/admin/admin_home.dart';
import 'package:hackathon/screens/alert_page.dart';

class AdminAlarmPage extends StatefulWidget {
  const AdminAlarmPage({super.key});

  @override
  State<AdminAlarmPage> createState() => _AdminAlarmPageState();
}

class _AdminAlarmPageState extends State<AdminAlarmPage> {
  Stream<QuerySnapshot> getUsersLocation() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text("Admin - Trigger Alarm",
                style: TextStyle(color: Colors.white)),
            centerTitle: true,
            leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.white,
                ))),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select User Location',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
                SizedBox(height: 10),
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
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCountry = value;
                      _selectedState = null; // Reset state when country changes
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
                    items: (_states[_selectedCountry] ?? []).map((state) {
                      return DropdownMenuItem(
                        value: state,
                        child: Text(
                          state,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedState = value;
                        _selectedCity = null; // Reset city when state changes
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
                    items: (_cities[_selectedState] ?? []).map((city) {
                      return DropdownMenuItem(
                        value: city,
                        child: Text(
                          city,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCity = value;
                      });
                    },
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _triggerAlarmForUsers(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                      "Alarm has been triggered to users!",
                    )));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: Text(
                    "Trigger Alarm",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Users Present in Selected Location',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
                SizedBox(height: 10),
                StreamBuilder<QuerySnapshot>(
                    stream: getUsersLocation(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Text('No users in the selected location.');
                      }
                      final filteredUsers = snapshot.data!.docs.where((doc) {
                        final location = doc.get('location');
                        if (location == null || location.isEmpty) {
                          return false;
                        }
                        List<dynamic> parts = location
                            .split(',')
                            .map((part) => part.trim())
                            .toList();

                        if (_selectedCountry == null ||
                            _selectedState == null ||
                            _selectedCity == null) {
                          return true;
                        }
                        return (parts.length == 3 &&
                            parts[0] == _selectedCity &&
                            parts[1] == _selectedState &&
                            parts[2] == _selectedCountry);
                      }).toList();
                      if (filteredUsers.isEmpty) {
                        return const Text('No users in the selected location.');
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          final data = filteredUsers[index].data()
                              as Map<String, dynamic>;
                          return ListTile(
                            title: Text(
                                data['location'] ?? 'Location not available',
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                          );
                        },
                      );
                    }),
              ],
            ),
          ),
        ));
  }

  Future<void> _triggerAlarmForUsers(BuildContext context) async {
    final QuerySnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    final filteredUsers = userSnapshot.docs.where((doc) {
      final location = doc.get('location');
      if (location == null || location.isEmpty) {
        return false;
      }
      List<dynamic> parts =
          location.split(',').map((part) => part.trim()).toList();
      if (_selectedCountry == null ||
          _selectedState == null ||
          _selectedCity == null) {
        return false;
      }

      return parts.length == 3 &&
          parts[0] == _selectedCity &&
          parts[1] == _selectedState &&
          parts[2] == _selectedCountry;
    }).toList();

    for (var doc in filteredUsers) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AlertPage(adminTriggered: true, previousScreen: "AdminAlarmPage"),
        ),
      );
    }
  }
}
