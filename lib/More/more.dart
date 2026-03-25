import 'package:firebase_auth/firebase_auth.dart';
import 'package:rngs/Bike_rental/Bike_rental.dart';
import 'package:rngs/Cart.dart';
import 'package:rngs/Home.dart';
import 'package:rngs/More/History.dart';
import 'package:rngs/More/HomeStations.dart';
import 'package:rngs/More/Kyc.dart';
import 'package:rngs/LoginScreen.dart';
import 'package:rngs/More/Message.dart';
import 'package:rngs/More/Profile.dart';
import 'package:flutter/material.dart';
import 'package:rngs/Process/process.dart';
import 'package:rngs/More/T&C.dart';
import 'package:rngs/More/Pri&pol.dart';
import 'package:rngs/More/About_us.dart';
import 'package:rngs/More/Contact_us.dart';
import 'package:rngs/More/ChatBot.dart';

class More extends StatefulWidget {
  @override
  _MoreState createState() => _MoreState();
}
class _MoreState extends State<More> {
  final List<Widget> module=[
    BikeRental(),
    CartPage(),
    Home(),
    Process(),
    More(),
  ];

  void _logout() async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, 
        MaterialPageRoute(builder: (context)=> LoginScreen()));
}
  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Menu', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            MenuItem(icon: Icons.person, text: "My Profile",
                onTap: () => _navigateToScreen(context, ProfileScreen())),
            MenuItem(
              icon: Icons.article,
              text: "KYC",
              onTap: () => _navigateToScreen(context,KycPage()),
              trailing: ElevatedButton(
                onPressed: () => _navigateToScreen(context,KycPage()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: Text("Update KYC"),
              ),
            ),
            MenuItem(icon: Icons.help, text: "ChatBot",
                onTap: () => _navigateToScreen(context, ChatbotScreen())),
            MenuItem(icon: Icons.history, text: "Ride History",
                onTap: () => _navigateToScreen(context, HistoryPage())),
            MenuItem(icon: Icons.message_outlined, text: "Message",
              onTap: () => _navigateToScreen(context, MessagePage()),),
            MenuItem(icon: Icons.home, text: "Home Stations",
              onTap: () => _navigateToScreen(context, Homestations()),),
            MenuItem(icon: Icons.description, text: "Terms & Conditions",
                onTap: () => _navigateToScreen(context, TermsAndConditionsPage())),
            MenuItem(icon: Icons.privacy_tip, text: "Privacy Policy",
                onTap: () => _navigateToScreen(context, PrivacyPolicyPage())),
            MenuItem(icon: Icons.info_outline_rounded, text:"About US",
                onTap: ()=>_navigateToScreen(context,AboutUsPage())),
            MenuItem(icon: Icons.contact_phone, text: "Contact Us",
                onTap: () => _navigateToScreen(context, ContactUsScreen())),
            Divider(color: Colors.black87),
            MenuItem(icon: Icons.logout, text: "Logout",onTap: _logout),
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget? trailing;
  final VoidCallback? onTap;

  MenuItem({required this.icon, required this.text, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(text, style: TextStyle(color: Colors.black87)),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
