import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qonnect/apis/address_book/address_book.dart';
import 'package:qonnect/models/address_book/users.dart';
import 'package:qonnect/models/chat/chat_model_repository.dart';
import 'package:qonnect/service_locators/locators.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<Users> allUsers = [];
  List<Users> filteredUsers = [];
  bool isLoading = true;
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final response = await AddressBookApi().getAddressBookUsers();
      if (response.statusCode == 200) {
        final data = response.data as List;

        List<Users> loadedUsers =
            data.map((json) => Users.fromJson(json)).toList();

        loadedUsers.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()),
        );
        setState(() {
          allUsers = loadedUsers;
          filteredUsers = loadedUsers;
        });
      } else {
        log(response.statusCode.toString(), name: "Failed to fetch users");
      }
    } catch (error) {
      log(error.toString(), name: "Error fetching users");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void startSearch() {
    setState(() {
      isSearching = true;
    });
  }

  void cancelSearch() {
    setState(() {
      isSearching = false;
      filteredUsers = allUsers;
      searchController.clear();
    });
  }

  void filterUsers(String query) {
    final filtered =
        allUsers.where((user) {
          final nameLower = user.name!.toLowerCase();
          final emailLower = user.email!.toLowerCase();
          final searchLower = query.toLowerCase();
          return nameLower.contains(searchLower) ||
              emailLower.contains(searchLower);
        }).toList();

    setState(() {
      filteredUsers = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            isSearching
                ? TextField(
                  controller: searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search by name or email',
                    border: InputBorder.none,
                  ),
                  onChanged: filterUsers,
                )
                : Text(
                  'Select User to Chat',
                  style: TextStyle(color: Colors.white),
                ),
        actions: [
          IconButton(
            icon: Icon(
              isSearching ? Icons.clear : Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              if (isSearching) {
                cancelSearch();
              } else {
                startSearch();
              }
            },
          ),
        ],
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : filteredUsers.isEmpty
              ? Center(child: Text('No users found.'))
              : ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  return ListTile(
                    title: Text(user.name!),
                    subtitle: Text(user.email!),
                    onTap: () {
                      getIt<ChatModelRepository>().updateChatModelRepo(
                        user.name!,
                        user.id!,
                      );
                      Navigator.pop(context); // Add this line to go back to messaging screen
                    },
                  );
                },
              ),
    );
  }
}
