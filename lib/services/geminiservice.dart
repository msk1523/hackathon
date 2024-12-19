import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hackathon/widget/app_constant.dart';

class GeminiService {
  final String _apiKey;
  final GenerativeModel _model;
  final String userName;

  GeminiService({required this.userName})
      : _apiKey = secretKey,
        _model = GenerativeModel(
          model: 'gemini-2.0-flash-exp',
          apiKey: secretKey,
          generationConfig: GenerationConfig(
            temperature: 0.8,
            topK: 40,
            topP: 0.95,
            maxOutputTokens: 8192,
            responseMimeType: 'text/plain',
          ),
        );

  Future<String?> sendMessage(String message) async {
    if (_apiKey.isEmpty) {
      throw Exception("API key not found");
    }
    final String prompt = """
You are a helpful and interactive chatbot designed to assist users with information related to disaster relief, safety, NGOs, and general awareness. Feel free to have a conversational tone and be engaging. If the user asks something irrelevant, ask them to be specific in the field of disaster and relief. Do not ask for order number or other related order questions.
""";

    final String greeting = "Hello $userName! How can I help you today?";

    try {
      final chat = _model.startChat();
      final content = Content.text("$greeting\n$prompt\nUser: $message");
      final response = await chat.sendMessage(content);
      return response.text;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
