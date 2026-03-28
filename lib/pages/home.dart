import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic> data = {};

  LinearGradient _backgroundGradient(bool isDaytime) {
    if (isDaytime) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFBEE9FF), Color(0xFF6FB3E0), Color(0xFF2A6F97)],
      );
    }

    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF081C3A), Color(0xFF123B64), Color(0xFF1B4965)],
    );
  }

  String _flagUrl(String code) {
    return 'https://flagcdn.com/w80/${code.toLowerCase()}.png';
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    data = data.isNotEmpty
        ? data
        : (args is Map ? Map<String, dynamic>.from(args) : {});

    if (data.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final bool isDaytime = data['isDaytime'] == true;
    final String location = data['location']?.toString() ?? 'Unknown';
    final String time = data['time']?.toString() ?? '--:--';
    final String date = data['date']?.toString() ?? '';
    final String countryCode = data['countryCode']?.toString() ?? 'UN';
    final String timezone = data['url']?.toString() ?? '';
    final String greeting = isDaytime ? 'Good Morning' : 'Good Evening';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: _backgroundGradient(isDaytime)),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'World Time',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontSize: 20,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      '/location',
                    );
                    if (!mounted || result is! Map) {
                      return;
                    }
                    setState(() {
                      data = {
                        'time': result['time'],
                        'date': result['date'],
                        'location': result['location'],
                        'isDaytime': result['isDaytime'],
                        'countryCode': result['countryCode'],
                        'url': result['url'],
                      };
                    });
                  },
                  icon: const Icon(Icons.travel_explore_rounded),
                  label: const Text('Change Location'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF174C73),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: isDaytime ? 0.22 : 0.15,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.35),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: Image.network(
                            _flagUrl(countryCode),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.flag_outlined,
                                color: Color(0xFF174C73),
                                size: 24,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        greeting,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.95),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        location,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        time,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 54,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        date,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (timezone.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          timezone,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
