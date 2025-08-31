import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lali/core/constants/colors.dart';

class AITravelAssistant {
  static final AITravelAssistant _instance = AITravelAssistant._internal();
  factory AITravelAssistant() => _instance;
  AITravelAssistant._internal();

  // Mock AI responses for demonstration
  final List<ChatMessage> _chatHistory = [];
  
  List<ChatMessage> get chatHistory => _chatHistory;

  Future<String> generateResponse(String userMessage) async {
    // Simulate AI processing delay
    await Future.delayed(const Duration(milliseconds: 1500));
    
    final response = _generateContextualResponse(userMessage.toLowerCase());
    
    // Add user message and AI response to history
    _chatHistory.add(ChatMessage(
      message: userMessage,
      isUser: true,
      timestamp: DateTime.now(),
    ));
    
    _chatHistory.add(ChatMessage(
      message: response,
      isUser: false,
      timestamp: DateTime.now(),
      suggestions: _generateSuggestions(userMessage.toLowerCase()),
    ));
    
    return response;
  }

  String _generateContextualResponse(String userMessage) {
    // Travel planning queries
    if (userMessage.contains('trip') || userMessage.contains('plan') || userMessage.contains('travel')) {
      return _getTravelPlanningResponse(userMessage);
    }
    
    // Tribal culture queries
    if (userMessage.contains('tribal') || userMessage.contains('culture') || userMessage.contains('traditional')) {
      return _getTribalCultureResponse(userMessage);
    }
    
    // Destination queries
    if (userMessage.contains('where') || userMessage.contains('destination') || userMessage.contains('place')) {
      return _getDestinationResponse(userMessage);
    }
    
    // Booking and reservation queries
    if (userMessage.contains('book') || userMessage.contains('reserve') || userMessage.contains('availability')) {
      return _getBookingResponse(userMessage);
    }
    
    // Shopping and marketplace queries
    if (userMessage.contains('buy') || userMessage.contains('shop') || userMessage.contains('product')) {
      return _getShoppingResponse(userMessage);
    }
    
    // Budget and pricing queries
    if (userMessage.contains('price') || userMessage.contains('cost') || userMessage.contains('budget')) {
      return _getBudgetResponse(userMessage);
    }
    
    // Weather and season queries
    if (userMessage.contains('weather') || userMessage.contains('season') || userMessage.contains('climate')) {
      return _getWeatherResponse(userMessage);
    }
    
    // Festival and events queries
    if (userMessage.contains('festival') || userMessage.contains('event') || userMessage.contains('celebration')) {
      return _getFestivalResponse(userMessage);
    }
    
    // General greeting and help
    if (userMessage.contains('hello') || userMessage.contains('hi') || userMessage.contains('help')) {
      return _getGreetingResponse();
    }
    
    // Default response for unrecognized queries
    return _getDefaultResponse();
  }

  String _getTravelPlanningResponse(String message) {
    final responses = [
      "I'd love to help you plan an amazing tribal adventure! 🗺️ What type of experience are you looking for? Cultural immersion, adventure activities, or spiritual journeys?",
      "Great! Let me suggest some fantastic tribal destinations. Are you interested in the coffee culture of Araku Valley, the tribal markets of Bastar, or perhaps the desert tribes of Rajasthan?",
      "Planning a tribal trip is exciting! 🌟 How many days do you have, and what's your preferred budget range? This will help me recommend the perfect experiences.",
      "For an authentic tribal experience, I recommend visiting during festival seasons. Would you like to know about upcoming tribal festivals and celebrations?",
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }

  String _getTribalCultureResponse(String message) {
    final responses = [
      "Tribal cultures in India are incredibly diverse! 🎭 Each region has unique traditions, art forms, and lifestyles. Are you interested in learning about a specific tribal community?",
      "Indian tribal heritage is fascinating! From the Warli art of Maharashtra to the Dhokra crafts of West Bengal, each tribe has preserved ancient traditions. What cultural aspect interests you most?",
      "Tribal communities are the guardians of India's oldest traditions 🏛️ They practice sustainable living, have rich oral histories, and create beautiful handicrafts. Would you like to experience this firsthand?",
      "The diversity of tribal cultures is amazing! You can experience traditional dance, music, cuisine, and crafts. Many tribes also have unique spiritual practices and festivals.",
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }

  String _getDestinationResponse(String message) {
    final responses = [
      "Here are some incredible tribal destinations 🌄:\n\n🏔️ Araku Valley, Andhra Pradesh - Coffee plantations and Padma Shri winning tribal art\n🌿 Bastar, Chhattisgarh - Rich Gond culture and crafts\n🏜️ Rajasthan - Desert tribal communities\n🌴 Kerala - Spice trails with tribal wisdom\n\nWhich region calls to you?",
      "For authentic tribal experiences, I recommend:\n\n✨ Manipur - Tribal villages and handloom traditions\n🎨 Odisha - Tribal paintings and dance forms\n🎭 Gujarat - Rann Utsav with tribal performances\n🏞️ Meghalaya - Living root bridges and Khasi culture\n\nWhat type of landscape do you prefer?",
      "Each tribal region offers unique experiences! Mountain tribes have different cultures from forest or desert communities. Are you drawn to:\n\n🏔️ Mountain regions\n🌲 Forest areas\n🏖️ Coastal communities\n🏜️ Desert regions",
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }

  String _getBookingResponse(String message) {
    final responses = [
      "I can help you with bookings! 📅 Most tribal experiences can be booked 1-2 weeks in advance. Would you like me to check availability for specific dates?",
      "Booking tribal experiences is easy! 🎫 You can book trips, homestays, cultural workshops, and festival tickets. What would you like to book?",
      "For the best experience, I recommend booking during these times:\n\n🌸 Oct-Mar: Perfect weather\n🎭 Festival seasons: Cultural celebrations\n🌾 Harvest time: Authentic village life\n\nWhen are you planning to travel?",
      "Most tribal homestays and experiences have flexible cancellation policies. Group bookings often get discounts too! How many people will be traveling?",
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }

  String _getShoppingResponse(String message) {
    final responses = [
      "Our tribal marketplace has amazing authentic products! 🛍️\n\n🎨 Handicrafts: Dhokra, Warli art, pottery\n🧵 Textiles: Handwoven sarees, shawls\n💍 Jewelry: Traditional silver ornaments\n🌿 Organic: Tribal honey, spices, teas\n\nWhat catches your interest?",
      "You'll love our authentic tribal products! Each purchase directly supports tribal artisans and their communities 💚 We have certified authentic items with stories behind each piece.",
      "Popular tribal products include:\n\n✨ Bamboo crafts from Assam\n🎭 Masks from Chhattisgarh\n🏺 Terracotta from West Bengal\n🌈 Tribal paintings from Odisha\n\nAll items come with authenticity certificates!",
      "Shopping with us means supporting tribal livelihoods! 🤝 We ensure fair prices for artisans and offer you genuine, handcrafted treasures with cultural significance.",
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }

  String _getBudgetResponse(String message) {
    final responses = [
      "Tribal experiences fit various budgets! 💰\n\n💚 Budget (₹2000-4000): Day trips, village visits\n💙 Mid-range (₹4000-8000): 2-3 day experiences\n💜 Premium (₹8000+): Luxury tribal resorts, private tours\n\nWhat's your preferred range?",
      "Great question about pricing! 📊 Tribal tourism offers excellent value:\n\n• Includes meals, accommodation, guides\n• Authentic experiences vs touristy places\n• Direct community support\n• Unique, life-changing memories\n\nMost travelers find it very reasonable!",
      "Budget planning tips:\n\n🌟 Book early for discounts\n👥 Group bookings save money\n🎭 Festival times have special packages\n🏠 Homestays are cost-effective\n\nWould you like a customized quote?",
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }

  String _getWeatherResponse(String message) {
    final responses = [
      "Weather planning is important! 🌤️\n\n🌸 Oct-Mar: Pleasant, perfect for most regions\n☀️ Apr-Jun: Hot, good for hill stations\n🌧️ Jul-Sep: Monsoon, lush but challenging\n❄️ Dec-Feb: Cool, ideal for desert regions\n\nWhich season works for you?",
      "Different tribal regions have varied climates:\n\n🏔️ Hill regions: Cool, carry woolens\n🌴 Coastal: Humid, light cotton clothes\n🏜️ Desert: Extreme, choose season carefully\n🌲 Forest: Moderate, insect protection needed",
      "Best weather for tribal experiences:\n\n✨ Post-monsoon (Oct-Nov): Fresh, green landscapes\n🌞 Winter (Dec-Feb): Comfortable temperatures\n🌸 Spring (Mar-Apr): Perfect for outdoor activities\n\nAvoid extreme summer in desert regions!",
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }

  String _getFestivalResponse(String message) {
    final responses = [
      "Tribal festivals are magical! 🎭 Here are some amazing ones:\n\n🎪 Hornbill Festival (Nagaland) - Dec\n🎨 Bastar Dussehra (Chhattisgarh) - Oct\n🌾 Sarhul Festival (Jharkhand) - Mar-Apr\n🎵 Moatsu Festival (Nagaland) - May\n\nWhich interests you most?",
      "Festival experiences include:\n\n🎭 Traditional dance performances\n🎵 Folk music concerts\n🍽️ Authentic tribal cuisine\n🎨 Craft exhibitions\n🏛️ Cultural ceremonies\n\nThese are once-in-a-lifetime experiences!",
      "Upcoming tribal festivals:\n\n🌸 Spring festivals (Mar-Apr): Harvest celebrations\n☀️ Summer festivals (May-Jun): Rain ceremonies\n🎭 Winter festivals (Nov-Feb): Cultural extravaganzas\n\nWould you like detailed schedules?",
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }

  String _getGreetingResponse() {
    final responses = [
      "Hello! 👋 Welcome to your AI Travel Assistant! I'm here to help you discover incredible tribal experiences across India. What adventure are you dreaming of?",
      "Hi there! 🌟 I'm your personal guide to authentic tribal tourism. Whether you want cultural immersion, adventure activities, or unique shopping, I'm here to help!",
      "Greetings, fellow explorer! 🗺️ Ready to discover India's rich tribal heritage? I can help you plan trips, find experiences, book accommodations, and much more!",
      "Welcome! ✨ I'm your AI assistant specialized in tribal tourism and culture. Ask me anything about destinations, experiences, bookings, or cultural insights!",
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }

  String _getDefaultResponse() {
    return "That's an interesting question! 🤔 While I specialize in tribal tourism and cultural experiences, I'd love to help you explore India's incredible tribal heritage. You can ask me about destinations, trip planning, cultural insights, bookings, or authentic products. What would you like to know?";
  }

  List<String> _generateSuggestions(String userMessage) {
    if (userMessage.contains('trip') || userMessage.contains('plan')) {
      return [
        'Show me popular destinations',
        'What\'s the best season to visit?',
        'Help me plan a 3-day trip',
        'Cultural vs adventure experiences?'
      ];
    }
    
    if (userMessage.contains('book')) {
      return [
        'Check availability for next month',
        'Group booking discounts?',
        'Cancellation policies',
        'What\'s included in packages?'
      ];
    }
    
    if (userMessage.contains('tribal') || userMessage.contains('culture')) {
      return [
        'Tell me about tribal festivals',
        'Authentic handicrafts available?',
        'Traditional food experiences',
        'Tribal art and crafts workshops'
      ];
    }
    
    return [
      'Popular tribal destinations',
      'Book a cultural experience',
      'Shopping for authentic products',
      'Upcoming festivals and events'
    ];
  }

  void clearChatHistory() {
    _chatHistory.clear();
  }
}

class ChatMessage {
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final List<String>? suggestions;
  final MessageType type;

  ChatMessage({
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.suggestions,
    this.type = MessageType.text,
  });
}

enum MessageType {
  text,
  image,
  location,
  booking,
  product,
}

// AI Chat Widget for easy integration
class AIChatWidget extends StatefulWidget {
  const AIChatWidget({super.key});

  @override
  State<AIChatWidget> createState() => _AIChatWidgetState();
}

class _AIChatWidgetState extends State<AIChatWidget>
    with TickerProviderStateMixin {
  final AITravelAssistant _assistant = AITravelAssistant();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  bool _isTyping = false;
  late AnimationController _typingController;
  late Animation<double> _typingAnimation;

  @override
  void initState() {
    super.initState();
    _typingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _typingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _typingController, curve: Curves.easeInOut),
    );
    
    // Add welcome message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _assistant.generateResponse("hello");
      setState(() {});
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _typingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tribalBackground,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy,
                size: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Travel Assistant',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Online • Ready to help',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: AppColors.tribalPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                _assistant.clearChatHistory();
              });
              _assistant.generateResponse("hello");
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _assistant.chatHistory.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _assistant.chatHistory.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                
                final message = _assistant.chatHistory[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          _buildInputSection(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: message.isUser 
              ? CrossAxisAlignment.end 
              : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: message.isUser 
                    ? AppColors.primaryGradient
                    : null,
                color: message.isUser 
                    ? null 
                    : Colors.white,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomRight: message.isUser 
                      ? const Radius.circular(4) 
                      : const Radius.circular(20),
                  bottomLeft: message.isUser 
                      ? const Radius.circular(20) 
                      : const Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.message,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: message.isUser ? Colors.white : AppColors.tribalText,
                  height: 1.4,
                ),
              ),
            ),
            
            // Suggestions for AI messages
            if (!message.isUser && message.suggestions != null)
              Container(
                margin: const EdgeInsets.only(top: 8),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: message.suggestions!.map((suggestion) {
                    return GestureDetector(
                      onTap: () => _sendMessage(suggestion),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.tribalSecondary),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          suggestion,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.tribalSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            
            // Timestamp
            Container(
              margin: const EdgeInsets.only(top: 4),
              child: Text(
                _formatTime(message.timestamp),
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'AI is typing',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(width: 8),
            AnimatedBuilder(
              animation: _typingAnimation,
              builder: (context, child) {
                return Row(
                  children: List.generate(3, (index) {
                    final delay = index * 0.3;
                    final opacity = ((_typingAnimation.value + delay) % 1.0);
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.tribalSecondary.withOpacity(opacity),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.tribalBackground,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.lightGrey),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Ask me anything about tribal tourism...',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.grey,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onSubmitted: (message) {
                  if (message.trim().isNotEmpty) {
                    _sendMessage(message);
                  }
                },
                enabled: !_isTyping,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.tribalPrimary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
              onPressed: _isTyping ? null : () {
                final message = _messageController.text.trim();
                if (message.isNotEmpty) {
                  _sendMessage(message);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String message) async {
    if (_isTyping) return;
    
    _messageController.clear();
    setState(() {
      _isTyping = true;
    });
    
    _typingController.repeat();
    
    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
    
    try {
      await _assistant.generateResponse(message);
      
      setState(() {
        _isTyping = false;
      });
      
      _typingController.reset();
      
      // Scroll to bottom after response
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    } catch (e) {
      setState(() {
        _isTyping = false;
      });
      _typingController.reset();
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${time.day}/${time.month}';
    }
  }
}