import 'dart:convert';
import 'package:code4fun_app/whoBenfents.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'aboutWassa.dart';
import 'aboutCode4funPage.dart';
import 'services.dart';
import 'gallary.dart';
import 'address.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isDarkMode = false; // مدیریت حالت تاریک
  String _selectedLanguage = "en"; // زبان پیش‌فرض انگلیسی
  List<Map<String, dynamic>> _cardsData = []; // داده‌های کارت‌ها

  @override
  void initState() {
    super.initState();
    _loadPreferences(); // بارگذاری زبان و حالت تاریک ذخیره‌شده
    _loadCardsData(); // بارگذاری کارت‌ها
  }

  // ذخیره تنظیمات در SharedPreferences
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("selectedLanguage", _selectedLanguage);
    await prefs.setBool("isDarkMode", _isDarkMode);
  }

  // بارگذاری تنظیمات ذخیره‌شده
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString("selectedLanguage") ?? "en";
      _isDarkMode = prefs.getBool("isDarkMode") ?? false;
    });
  }

  // تغییر زبان
  void _changeLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
    });
    _savePreferences(); // ذخیره زبان
    _loadCardsData(); // به‌روزرسانی کارت‌ها
  }

  // تغییر حالت تاریک/روشن
  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    _savePreferences(); // ذخیره حالت تاریک
  }

  // بارگذاری داده‌های کارت‌ها
  void _loadCardsData() {
    setState(() {
      _cardsData = [
        {
          'title': _selectedLanguage == 'en' ? 'About WASSA' : 'درباره واسا',
          'subtitle': _selectedLanguage == 'en'
              ? 'Learn more about the WASSA initiative.'
              : 'اطلاعات بیشتر درباره واسا',
          'page': AboutWassaPage(
              language: '_selectedLanguage', isDarkMode: _isDarkMode, data: {},),
          'gradientColors': [Colors.orangeAccent, Colors.deepOrange],
        },
        {
          'title':
              _selectedLanguage == 'en' ? 'About CODE4FUN' : 'درباره کد 4 فان',
          'subtitle': _selectedLanguage == 'en'
              ? 'Discover the CODE4FUN community.'
              : 'جامعه کد4فان را کشف کنید.',
          'page': AboutCode4FunPage(
              language: _selectedLanguage, isDarkMode: _isDarkMode, data: {}),
          'gradientColors': [Colors.greenAccent, Colors.teal],
        },
        {
          'title': _selectedLanguage == 'en' ? 'Services' : 'خدمات',
          'subtitle': _selectedLanguage == 'en'
              ? 'Explore web and mobile development services.'
              : 'خدمات توسعه وب و موبایل را کشف کنید',
          'page': ServicesPage(
              language: _selectedLanguage, isDarkMode: _isDarkMode, data: {}),
          'gradientColors': [Colors.purpleAccent, Colors.deepPurple],
        },
        {
          'title': _selectedLanguage == 'en'
              ? 'Who Benefits'
              : 'چه کسانی بهرمند می شوند؟',
          'subtitle': _selectedLanguage == 'en'
              ? 'Learn about who benefits from WASSA.'
              : 'بیاموزید درمورد کسانی که از wassa فایده می برند',
          'page': WhoBenefitsPage(
              language: _selectedLanguage, isDarkMode: _isDarkMode, data: {}
          ),
          'gradientColors': [Colors.lightBlueAccent, Colors.blueAccent],
        },
        {
          'title': _selectedLanguage == 'en' ? 'Gallery' : 'گالری',
          'subtitle': _selectedLanguage == 'en'
              ? 'View pictures of students and projects.'
              : 'مشاهده تصاویر دانش آموزان و پروژه ها',
          'page': GalleryPage(
              // language: _selectedLanguage, isDarkMode: _isDarkMode, data: {}
          ),
          'gradientColors': [Colors.redAccent, Colors.orangeAccent],
        },
        {
          'title': _selectedLanguage == 'en' ? 'Address' : 'آدرس',
          'subtitle': _selectedLanguage == 'en'
              ? 'Find out the WASSA office location.'
              : 'محل دفتر واسا را پیدا کنید',
          'page': AddressPage(
              language: _selectedLanguage, isDarkMode: _isDarkMode, data: {}),
          'gradientColors': [Colors.blueGrey, Colors.black54],
        },
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        drawer: _buildDrawer(),
        body: Stack(
          children: [
            Container(
              color: Colors.lightBlueAccent,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildWelcomeMessage(),
                Expanded(child: _buildCardsList()),
              ],
            ),
            _buildFloatingActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(Icons.person, color: Colors.blueAccent, size: 40),
                ),
                SizedBox(height: 10),
                Text(
                  _selectedLanguage == 'en' ? "Welcome!" : "خوش آمدید",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _selectedLanguage == 'en' ? "Explore and Learn" : "بخوانید و بیاموزید",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              _selectedLanguage == 'en' ? "Settings" : "تنظیمات",

            ),
            onTap: () => _showSettingsDialog(context),
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text(
              _selectedLanguage == 'en' ? "Share" : "به اشتراک گذاشتند",

            ),
            onTap: () => Share.share('Check out WASSA: https://example.com'),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(_selectedLanguage == 'en' ? "Exit" : "خروج",
             ),
            onTap: () => SystemNavigator.pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white70,
            radius: 25,
            child: Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.list, color: Colors.black54, size: 30),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Center(
      child: Text(
        _selectedLanguage == 'en' ? "Welcome to WASSA" : "خوش آمدید به واسا",
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCardsList() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isDarkMode ? Colors.black : Colors.white,
          // color: ,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ListView.builder(
          itemCount: _cardsData.length,
          itemBuilder: (context, index) {
            final card = _cardsData[index];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => card['page']),
              ),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: card['gradientColors'],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card['title'],
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        card['subtitle'],
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context,
      {required String title,
      required String subtitle,
      required Widget page,
      required List<Color> gradientColors}) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      ),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton(
        backgroundColor: Colors.white54,
        child: Icon(Icons.location_on, color: Colors.black87),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddressPage(
              data: {},
              language: _selectedLanguage,
              isDarkMode: _isDarkMode,
            ),
          ),
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_selectedLanguage == 'en' ? "Setting" : "تنظیمات",style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.language),
                title: Text(_selectedLanguage == 'en' ? "Change Language" : "تعقییر زبان"),
                onTap: () => _showLanguageDialog(context),
              ),
              Divider(),
              SwitchListTile(
                secondary: Icon(Icons.brightness_6),
                title: Text(_selectedLanguage == 'en' ? "Dark Mode" : "حالت تاریک"),
                value: _isDarkMode,
                onChanged: (bool value) {
                  setState(() {
                    _isDarkMode = value;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          _selectedLanguage == 'en' ? "Select Language" : "انتخاب زبان",
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Image.asset(
                'assets/flags/en.png',
                width: 24,
                height: 24,
              ),
              title: Text("English"),
              onTap: () {
                Navigator.pop(context);
                _changeLanguage("en");
              },
            ),
            ListTile(
              leading: Image.asset(
                'assets/flags/fa.png',
                width: 24,
                height: 24,
              ),
              title: Text("فارسی"),
              onTap: () {
                Navigator.pop(context);
                _changeLanguage("fa");
              },
            ),
          ],
        ),
      ),
    );
  }
}

//
// import 'dart:convert';
// import 'package:code4fun_app/whoBenfents.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'aboutWassa.dart';
// import 'aboutCode4funPage.dart';
// import 'services.dart';
// import 'gallary.dart';
// import 'address.dart';
//
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   bool _isDarkMode = false; // مدیریت حالت تاریک
//   String _selectedLanguage = "en"; // زبان پیش‌فرض انگلیسی
//   List<Map<String, dynamic>> _cardsData = []; // داده‌های کارت‌ها
//
//
//   @override
//   void initState() {
//     super.initState();
//     _loadLanguagePreference(); // بارگذاری زبان ذخیره‌شده
//     _loadCardsData(); // بارگذاری کارت‌ها
//   }
//
//   // ذخیره زبان انتخاب‌شده
//   Future<void> _saveLanguagePreference(String language) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString("selectedLanguage", language);
//   }
//
// // بازیابی داده‌ها از حافظه محلی
//   Future<Map<String, dynamic>> _loadDataLocally(String key) async {
//     final prefs = await SharedPreferences.getInstance();
//     final data = prefs.getString(key);
//     return data != null ? json.decode(data) : {};
//   }
//   String _selectedLanguage = "en"; // پیش‌فرض انگلیسی
//
//   void _changeLanguage(String language) {
//     setState(() {
//       _selectedLanguage = language;
//     });
//   }
//
//   Future<void> _checkNetworkStatus() async {
//     final connectivityResult = await Connectivity().checkConnectivity();
//     setState(() {
//       _isOnline = connectivityResult != ConnectivityResult.none;
//     });
//   }
//
//   void _loadCardsData() {
//     // Sample data (replace with Firebase fetching if online)
//     setState(() {
//       _cardsData = [
//         {
//           'title': 'About WASSA',
//           'subtitle': 'Learn more about the WASSA initiative.',
//           'page': AboutWassaPage(
//             language: '_selectedLanguage', isDarkMode: _isDarkMode,
//           ),
//           'gradientColors': [Colors.orangeAccent, Colors.deepOrange],
//
//         },
//
//         {
//           'title': 'About CODE4FUN',
//           'subtitle': 'Discover the CODE4FUN community.',
//           'page': AboutCode4Fun(
//             data: {}, language: '', isDarkMode: _isDarkMode,
//           ),
//           'gradientColors': [Colors.greenAccent, Colors.teal],
//         },
//         {
//           'title': 'Services',
//           'subtitle': 'Explore web and mobile development services.',
//           'page': ServicesPage(
//             data: {}, language: '',
//           ),
//           'gradientColors': [Colors.purpleAccent, Colors.deepPurple],
//         },
//         {
//           'title': 'Who Benefits',
//           'subtitle': 'Learn about who benefits from WASSA.',
//           'page': WhoBenefitsPage(
//             data: {}, language: '',
//           ),
//           'gradientColors': [Colors.lightBlueAccent, Colors.blueAccent],
//         },
//         {
//           'title': 'Gallery',
//           'subtitle': 'View pictures of students and projects.',
//           'page': GalleryPage(
//             data: {}, language: '',
//           ),
//           'gradientColors': [Colors.redAccent, Colors.orangeAccent],
//         },
//         {
//           'title': 'Address',
//           'subtitle': 'Find out the WASSA office location.',
//           'page': AddressPage(
//             data: {}, language: '',
//           ),
//           'gradientColors': [Colors.blueGrey, Colors.black54],
//         },
//       ];
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: _buildDrawer(),
//       body: Stack(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildHeader(),
//               _buildWelcomeMessage(),
//               _isOnline ? _buildCardsList() : _buildOfflineMessage(),
//             ],
//           ),
//           _buildFloatingActionButton(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDrawer() {
//     return Drawer(
//       child: ListView(
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.blueAccent, Colors.lightBlue],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CircleAvatar(
//                   backgroundColor: Colors.white,
//                   radius: 30,
//                   child: Icon(Icons.person, color: Colors.blueAccent, size: 40),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   "Welcome!",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   "Explore and Learn",
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 16,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.settings),
//             title: Text("Settings"),
//             onTap: () => _showSettingsDialog(context),
//           ),
//           ListTile(
//             leading: Icon(Icons.share),
//             title: Text("Share"),
//             onTap: () => Share.share('Check out WASSA: https://example.com'),
//           ),
//           ListTile(
//             leading: Icon(Icons.exit_to_app),
//             title: Text("Exit"),
//             onTap: () => SystemNavigator.pop(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundColor: Colors.white70,
//             radius: 25,
//             child: Builder(
//               builder: (context) => IconButton(
//                 icon: Icon(Icons.list, color: Colors.black54, size: 30),
//                 onPressed: () => Scaffold.of(context).openDrawer(),
//               ),
//             ),
//           ),
//           SizedBox(width: 16),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildWelcomeMessage() {
//     return Center(
//       child: Text(
//         "Welcome to WASSA",
//         style: TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//         textAlign: TextAlign.center,
//       ),
//     );
//   }
//
//   Widget _buildCardsList() {
//     return Expanded(
//       child: Container(
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//         ),
//         child: ListView.builder(
//           itemCount: _cardsData.length,
//           itemBuilder: (context, index) {
//             final card = _cardsData[index];
//             return _buildCard(
//               context,
//               title: card['title'],
//               subtitle: card['subtitle'],
//               page: card['page'],
//               gradientColors: card['gradientColors'],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildOfflineMessage() {
//     return Center(
//       child: Text(
//         "No internet connection. Please check your network.",
//         style: TextStyle(fontSize: 16, color: Colors.redAccent),
//       ),
//     );
//   }
//
//   Widget _buildCard(BuildContext context,
//       {required String title,
//         required String subtitle,
//         required Widget page,
//         required List<Color> gradientColors}) {
//     return GestureDetector(
//       onTap: () => Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => page),
//       ),
//       child: Card(
//         elevation: 5,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         child: Container(
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: gradientColors,
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 subtitle,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.white70,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFloatingActionButton() {
//     return Positioned(
//       bottom: 20,
//       right: 20,
//       child: FloatingActionButton(
//         backgroundColor: Colors.white54,
//         child: Icon(Icons.location_on, color: Colors.black87),
//         onPressed: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => AddressPage(
//                 data: {}, language: '',
//               )),
//         ),
//       ),
//     );
//   }
//
//   void _showSettingsDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Settings"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: Icon(Icons.language),
//                 title: Text("Change Language"),
//                 onTap: () => _showLanguageDialog(context),
//               ),
//               Divider(),
//               SwitchListTile(
//                 secondary: Icon(Icons.brightness_6),
//                 title: Text("Dark Mode"),
//                 value: _isDarkMode,
//                 onChanged: (bool value) {
//                   setState(() {
//                     _isDarkMode = value;
//                   });
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   void _showLanguageDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text("Select Language"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: Image.asset(
//                 'assets/flags/en.png',
//                 width: 24,
//                 height: 24,
//               ),
//               title: Text("English"),
//               onTap: () => Navigator.pop(context),
//             ),
//             ListTile(
//               leading: Image.asset(
//                 'assets/flags/fa.png',
//                 width: 24,
//                 height: 24,
//               ),
//               title: Text("Farsi"),
//               onTap: () => Navigator.pop(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
