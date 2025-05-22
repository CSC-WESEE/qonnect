import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';

class SocketService {
  late IO.Socket socket;
  final Connectivity _connectivity = Connectivity();
  late Stream<ConnectivityResult> _connectivityStream;
  String? _userId;

  void connect() {
    try {
      // log("Attempting to connect to: ${dotenv.env['CONNECTION_URL']}");
      socket = IO.io(dotenv.env['CONNECTION_URL'], <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": true,
        "reconnection": true,
        "reconnectionAttempts": 50,
        "reconnectionDelay": 1000,
        "secure": true,
        "rejectUnauthorized": false,
      });

      socket.connect();
      _setupSocketListeners();
      socket.on('message', (data) {
        log('Hello78787878787');
      });
    } catch (e) {
      log("Socket connection error: ${e.toString()}");
    }
  }

  void _setupSocketListeners() {
    socket.on('disconnect', (_) {
      log("Disconnected from server.");
      // No need to call _reconnect() here since reconnect is handled on network change
    });

    socket.on('connect', (_) {
      log("Connected to server.");
      if (_userId != null) {
        socket.emit("signin", _userId);
        // updateSelfLocation(_userId);
        log("Re-emitted signin for userId: $_userId after reconnection.");
      }
    });
  }

  void _listenToNetworkChanges() {
    _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      // Check if there's any non-disconnected result in the list
      if (results.any((result) => result != ConnectivityResult.none)) {
        _attemptReconnect();
      }
    });
  }

  void _attemptReconnect() {
    if (socket.disconnected) {
      try {
        log("Network available, attempting to reconnect socket...");
        // socket.connect();
      } catch (error) {
        log("Reconnect error: ${error.toString()}");
      }
    } else {
      log("Socket already connected or in process of connecting.");
    }
  }

  SocketService() {
    connect();
    _listenToNetworkChanges();
  }
}
