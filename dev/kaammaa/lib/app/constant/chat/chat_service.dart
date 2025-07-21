import 'dart:convert';
import 'package:flutter/material.dart'; // Needed for ValueNotifier
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  IO.Socket? _socket;
  bool _listenersAttached = false;

  final String baseUrl = "http://192.168.1.70:5050";
  final String token;
  final String jobId;
  final String? currentUserId;

  final ValueNotifier<List<Map<String, dynamic>>> messagesNotifier =
      ValueNotifier([]);

  ChatService({required this.token, required this.jobId, this.currentUserId});

  Future<void> fetchChatHistory() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/chat/$jobId"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final chat = data["chat"];
        messagesNotifier.value = List<Map<String, dynamic>>.from(
          chat["messages"],
        );
        print(
          "📜 Chat history loaded: ${messagesNotifier.value.length} messages",
        );
      } else {
        print("⚠️ Failed to fetch chat history: ${response.body}");
      }
    } catch (err) {
      print("❌ Error fetching chat history: $err");
    }
  }

  void connect() {
    if (_socket != null && _socket!.connected) {
      print("Socket already connected for jobId: $jobId");
      return;
    }

    if (_socket == null || !_socket!.connected) {
      _socket = IO.io(
        baseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build(),
      );

      _socket!.connect();
    }

    _socket!.onConnect((_) {
      print("✅ Socket connected");
      _socket!.emit("joinRoom", {"jobId": jobId});
    });

    if (!_listenersAttached) {
      _listenersAttached = true;

      _socket!.on("receiveMessage", (data) {
        print("📩 New message received: $data");
        final currentMessages = messagesNotifier.value;
        messagesNotifier.value = List.from(currentMessages)
          ..add(Map<String, dynamic>.from(data));
      });

      _socket!.onDisconnect((_) => print("❌ Socket disconnected"));
      _socket!.onError((error) => print("❌ Socket error: $error"));
    }
  }

  void sendMessage(String content) {
    final optimisticMessage = {
      "senderId": currentUserId ?? "optimistic_customer",
      "content": content,
      "createdAt": DateTime.now().toIso8601String(),
    };

    messagesNotifier.value = List.from(messagesNotifier.value)
      ..add(optimisticMessage);

    final socketMessage = {"jobId": jobId, "content": content};

    if (_socket != null && _socket!.connected) {
      _socket!.emit("sendMessage", socketMessage);
    } else {
      print("⚠️ Socket not connected. Message not emitted.");
    }

    http
        .post(
          Uri.parse("$baseUrl/api/chat/message"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({"jobId": jobId, "content": content}),
        )
        .then((res) {
          if (res.statusCode == 200) {
            print("💾 Message saved to DB");
          } else {
            print("⚠️ Failed to save message: ${res.body}");
          }
        })
        .catchError((err) {
          print("❌ Error saving message: $err");
        });
  }

  void dispose() {
    if (_socket != null) {
      _socket!.off("receiveMessage");
      _socket!.disconnect();
      _socket = null;
      _listenersAttached = false;
    }
    messagesNotifier.dispose();
    print("🔌 Socket disconnected and ChatService disposed");
  }
}
