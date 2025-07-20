import 'dart:convert';
import 'package:flutter/material.dart'; // Needed for ValueNotifier
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  // Change to nullable type: IO.Socket? _socket;
  // Initialize to null explicitly to ensure it's in a known state.
  IO.Socket? _socket;

  final String baseUrl =
      "http://192.168.1.70:5050"; // TODO: Use a constant for this base URL
  final String token;
  final String jobId;
  final String? currentUserId; // Used for optimistic self-messages

  final ValueNotifier<List<Map<String, dynamic>>> messagesNotifier =
      ValueNotifier([]);

  ChatService({
    required this.token,
    required this.jobId,
    this.currentUserId, // Passed from UI, representing the logged-in customer
  });

  void connect() {
    // CHECK 1: Ensure _socket is not null AND connected before returning.
    // This avoids the LateInitializationError on first access.
    if (_socket != null && _socket!.connected) {
      print("Socket already connected for jobId: $jobId");
      return;
    }

    // Initialize _socket only if it's null or disconnected (if it existed before)
    if (_socket == null || (_socket != null && !_socket!.connected)) {
      _socket = IO.io(
        baseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build(),
      );

      _socket!.connect(); // Use ! because we just initialized it
    }

    // Now that _socket is guaranteed to be initialized, attach listeners
    // and emit events using ! (null assertion operator).
    // It's safer to attach listeners only once per socket instance,
    // so consider if these should be within the `if (_socket == null || ...)` block
    // or handled via a separate `setupListeners` method that ensures uniqueness.
    // For now, attaching them after ensuring connection:
    _socket!.onConnect((_) {
      print("✅ Socket connected");
      _socket!.emit("joinRoom", {"jobId": jobId});
    });

    _socket!.on("receiveMessage", (data) {
      print("📩 New message received: ${data}");
      // Removed messagesNotifier.hasListeners check as it's a protected member
      final currentMessages = messagesNotifier.value;
      messagesNotifier.value = List.from(currentMessages)
        ..add(Map<String, dynamic>.from(data));
    });

    _socket!.onDisconnect((_) => print("❌ Socket disconnected"));
    _socket!.onError((error) => print("❌ Socket error: $error"));
  }

  /// Emits the message via socket and saves it via REST API
  void sendMessage(String content) {
    // Optimistically add to UI for immediate display.
    messagesNotifier.value = List.from(messagesNotifier.value)..add({
      "senderId":
          currentUserId ?? "optimistic_customer", // Use actual currentUserId
      "content": content,
      "createdAt": DateTime.now().toIso8601String(),
    });

    final socketMessage = {"jobId": jobId, "content": content};

    // CHECK 2: Only emit if _socket is initialized and connected
    if (_socket != null && _socket!.connected) {
      _socket!.emit("sendMessage", socketMessage);
    } else {
      print(
        "⚠️ Socket not connected, message not emitted via socket. Ensure connect() was successful.",
      );
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

  /// Fetch chat history from backend
  Future<void> fetchChatHistory() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/chat/$jobId"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final chat = data["chat"];
        // Removed messagesNotifier.hasListeners and messagesNotifier.value != null checks
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

  void dispose() {
    // CHECK 3: Only disconnect if _socket is not null
    if (_socket != null) {
      _socket!.disconnect();
      _socket = null; // Clear the reference to allow garbage collection
    }
    messagesNotifier.dispose();
    print("🔌 Socket disconnected");
  }
}
