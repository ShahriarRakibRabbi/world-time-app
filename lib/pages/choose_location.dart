import 'package:flutter/material.dart';
import 'package:world_time_app/services/world_time.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({super.key});

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  List<WorldTime> locations = [
    WorldTime(url: 'Asia/Dhaka', location: 'Dhaka', countryCode: 'BD'),
    WorldTime(url: 'Europe/London', location: 'London', countryCode: 'GB'),
    WorldTime(url: 'Europe/Athens', location: 'Athens', countryCode: 'GR'),
    WorldTime(url: 'Europe/Berlin', location: 'Berlin', countryCode: 'DE'),
    WorldTime(url: 'Africa/Cairo', location: 'Cairo', countryCode: 'EG'),
    WorldTime(url: 'Africa/Nairobi', location: 'Nairobi', countryCode: 'KE'),
    WorldTime(url: 'America/Chicago', location: 'Chicago', countryCode: 'US'),
    WorldTime(url: 'America/New_York', location: 'New York', countryCode: 'US'),
    WorldTime(url: 'Asia/Seoul', location: 'Seoul', countryCode: 'KR'),
    WorldTime(url: 'Asia/Jakarta', location: 'Jakarta', countryCode: 'ID'),
  ];

  List<WorldTime> get filteredLocations {
    if (_searchText.trim().isEmpty) {
      return locations;
    }

    return locations.where((location) {
      final locationName = location.location?.toLowerCase() ?? '';
      final query = _searchText.toLowerCase();
      return locationName.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void updateTime(WorldTime instance) async {
    await instance.getTime();
    if (!mounted) {
      return;
    }

    Navigator.pop(context, {
      'location': instance.location,
      'time': instance.time,
      'date': instance.date,
      'isDaytime': instance.isDaytime,
      'countryCode': instance.countryCode,
      'url': instance.url,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FA),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF174C73),
        title: const Text('Choose a Location'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search city...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchText.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchText = '';
                          });
                        },
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredLocations.length,
              itemBuilder: (context, index) {
                final location = filteredLocations[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 8.0,
                  ),
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      onTap: () {
                        updateTime(location);
                      },
                      title: Text(
                        location.location.toString(),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(location.url.toString()),
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: Image.network(
                            location.getFlagImageUrl(),
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.flag_outlined,
                                color: Color(0xFF174C73),
                              );
                            },
                          ),
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
