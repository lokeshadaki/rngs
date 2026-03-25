import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:async';

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Map<String, String>> messages = [
    {"bot": "Hello! How can I assist you today?"}
  ];
  final TextEditingController _controller = TextEditingController();
  bool isTyping = false;

  final List<String> defaultQuestions = [
    "Is a driver provided with the bike?",
    "What safety measures are included?",
    "Do I need a license to rent a bike?",
    "How do I end my ride?",
    "Can I ride in bad weather?",
    "What should I do if I face an issue during my ride?",
    "How much does a RideNGo trip cost?",
    "Can I get a refund if I cancel my booking?",
    "Can I pause my ride?",
    "Where can I park the bike after my ride?",
    "In which cities is RideNGo available?",
    "Can I book multiple bikes at once?"
  ];


  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      setState(() {
        messages.add({"user": message});
        isTyping = true;
        _controller.clear();
      });
      Future.delayed(Duration(seconds: 1), () => _botResponse(message));
    }
  }

  void _botResponse(String userMessage) {
    String response;
    userMessage = userMessage.toLowerCase();

    if (userMessage.contains("driver")) {
      response = "No—RideNGo offers rider-less rentals. You are in full control of your ride, giving you complete freedom over your route and schedule.";
    } else if (userMessage.contains("safety")) {
      response = "Each RideNGo bike comes with a helmet to keep you safe and comfortable.";
    } else if (userMessage.contains("license")) {
      response = "Yes, a valid two-wheeler license is required. We verify your documents during the sign-up process to ensure compliance and safety.";
    } else if (userMessage.contains("end my ride")) {
      response = "Park the bike in a designated zone, ensure it’s locked, and tap “End Ride” in the app. You’ll receive a ride summary and receipt instantly.";
    } else if (userMessage.contains("bad weather")) {
      response = "Absolutely! RideNGo bikes come equipped with weather-protection gear like umbrellas and helmets to keep you safe and dry.";
    } else if (userMessage.contains("issue") || userMessage.contains("problem")) {
      response = "Tap the Support button in the app or contact us through the Help section. Our team is available 24/7 to assist you.";
    } else if (userMessage.contains("trip cost") || userMessage.contains("pricing")) {
      response = "Pricing is based on duration and starts as low as per bike. You’ll see the estimated cost before you confirm your booking.";
    } else if (userMessage.contains("refund") || userMessage.contains("cancel")) {
      response = "Yes, if you cancel within the allowed time frame before the ride starts. Cancellation policies are visible in the booking screen.";
    } else if (userMessage.contains("pause my ride")) {
      response = "Yes, you can pause your ride any where any time within a time limit.";
    } else if (userMessage.contains("park the bike")) {
      response = "Please return the bike to any RideNGo-designated parking zone shown on the map. Improper parking may result in a fine.";
    } else if (userMessage.contains("cities") || userMessage.contains("available in")) {
      response = "RideNGo is currently available in Solapur and expanding soon! You’ll see supported areas when you open the app.";
    } else if (userMessage.contains("multiple bikes")) {
      response = "Currently, one bike can be rented per account at a time—for safety and accountability. Group features are coming soon!";
    } else {
      response = "I'm here to help! Please ask me about renting, pricing, or support.";
    }

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isTyping = false;
        messages.add({"bot": response});
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with RideNGo Bot", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: messages.length + (isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (isTyping && index == messages.length) {
                    return FadeIn(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Typing...", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                        ),
                      ),
                    );
                  }
                  final message = messages[index];
                  final isUser = message.containsKey("user");
                  return SlideInUp(
                    child: Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.black : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
                          ],
                        ),
                        child: Text(
                          isUser ? message["user"]! : message["bot"]!,
                          style: TextStyle(
                            color: isUser ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Quick Questions:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                  SizedBox(height: 5),
                  Container(
                    height: 150,
                    child: ListView.builder(
                      itemCount: defaultQuestions.length,
                      itemBuilder: (context, index) {
                        return ZoomIn(
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            color: Colors.white,
                            child: ListTile(
                              title: Text(defaultQuestions[index], style: TextStyle(color: Colors.black)),
                              onTap: () => _sendMessage(defaultQuestions[index]),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: () => _sendMessage(_controller.text),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}