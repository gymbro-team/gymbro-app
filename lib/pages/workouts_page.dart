import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gymbro_app/core/constants.dart';
import 'package:gymbro_app/pages/auth/auth_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({super.key});

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  late List<dynamic> workouts = []; // List to hold fetched workouts

  @override
  void initState() {
    super.initState();
    fetchWorkouts();
  }

  void fetchWorkouts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      final url = '$API_URL/workouts';
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        List<dynamic> decodedResponse = jsonDecode(response.body);
        setState(() {
          workouts = decodedResponse;
        });
      } else {
        print('Failed to fetch workouts');
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthPage()),
      );
    }
  }

  void deleteWorkout(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      final url = '$API_URL/workouts/$id';
      final response = await http.delete(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        fetchWorkouts();
      } else {
        print('Failed to delete workout');
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthPage()),
      );
    }
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthPage()),
    );
  }

  void _showAddWorkoutModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: AddWorkoutForm(onAddWorkout: _addWorkout),
        );
      },
    );
  }

  void _addWorkout(String name, String weekday, String description) async {
    //make a POST request to the API to add the workout
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      final url = '$API_URL/workouts';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'week_day': int.parse(weekday),
          'description': description,
          'icon': '',
          'cover_image': '',
        }),
      );

      if (response.statusCode == 201) {
        setState(() {
          workouts.add({'name': name, 'week_day': weekday, 'description': description});
        });
        fetchWorkouts();
      } else {
        print('Failed to add workout');
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthPage()),
      );
    }
  }

  String _weekdayToName(String weekday) {
    switch (weekday) {
      case '1':
        return 'Monday';
      case '2':
        return 'Tuesday';
      case '3':
        return 'Wednesday';
      case '4':
        return 'Thursday';
      case '5':
        return 'Friday';
      case '6':
        return 'Saturday';
      case '7':
        return 'Sunday';
      default:
        return 'Monday';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Your Workouts', style: TextStyle(color: Colors.white70)),
        backgroundColor: Colors.black26,
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWorkoutModal(context),
        backgroundColor: Colors.black26,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          return SizedBox(
            height: 120,
            child: Card(
              color: Colors.black26,
              child: Center(
                child: ListTile(
                  title: Text(
                    workouts[index]['name'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _weekdayToName(workouts[index]['week_day'].toString()),
                        style: const TextStyle(color: Colors.white70),
                      ),
                      Text(
                        workouts[index]['description'] ?? '',
                        style: const TextStyle(color: Colors.white54),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.white),
                    onPressed: () {
                      deleteWorkout(workouts[index]['id']);
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AddWorkoutForm extends StatefulWidget {
  final Function(String, String, String) onAddWorkout;

  const AddWorkoutForm({super.key, required this.onAddWorkout});

  @override
  _AddWorkoutFormState createState() => _AddWorkoutFormState();
}

class _AddWorkoutFormState extends State<AddWorkoutForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedWeekday;

  void _submit() {
    if (_formKey.currentState!.validate() && _selectedWeekday != null) {
      widget.onAddWorkout(_nameController.text, _selectedWeekday!, _descriptionController.text);
      Navigator.of(context).pop();
    }
  }

  String _getWeekdayIndex(String weekday) {
    switch (weekday) {
      case 'Monday':
        return '1';
      case 'Tuesday':
        return '2';
      case 'Wednesday':
        return '3';
      case 'Thursday':
        return '4';
      case 'Friday':
        return '5';
      case 'Saturday':
        return '6';
      case 'Sunday':
        return '7';
      default:
        return '1';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Workout Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: _selectedWeekday,
              decoration: const InputDecoration(labelText: 'Weekday'),
              items: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'].map((weekday) {
                return DropdownMenuItem(
                  value: _getWeekdayIndex(weekday).toString(),
                  child: Text(weekday),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedWeekday = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a weekday';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.all(20.0),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Add Workout',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
