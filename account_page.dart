import 'package:flutter/material.dart';
import 'edit_profile_page.dart';
import 'history_page.dart'; // contains enum HistoryFilter

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String _name = 'John Doe';
  String _email = 'john.doe@company.com';
  String? _department;
  String? _location;

  // Dummy history data – used by HistoryPage
  final List<Map<String, dynamic>> _history = [
    {
      'title': 'Ergonomic Office Chair',
      'type': HistoryFilter.sold,
      'date': '2025-11-20',
      'amount': 2500.0,
    },
    {
      'title': 'Mechanical Keyboard',
      'type': HistoryFilter.donated,
      'date': '2025-11-18',
      'amount': 0.0,
    },
    {
      'title': 'Projector (Meeting Room)',
      'type': HistoryFilter.bought,
      'date': '2025-11-10',
      'amount': 500.0,
    },
  ];

  void _onEditProfile() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(
          name: _name,
          email: _email,
          department: _department,
          location: _location,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _name = (result['name'] as String?) ?? _name;
        _department = result['department'] as String?;
        _location = result['location'] as String?;
      });
    }
  }

  void _openHistory(HistoryFilter filter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HistoryPage(
          filter: filter,
          history: _history,
        ),
      ),
    );
  }

  void _onHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Help & Support (TODO: implement)'),
      ),
    );
  }

  void _showLogoutOptions() {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout from this device'),
            onTap: () {
              Navigator.pop(context);
              _onLogoutThisDevice();
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout from all devices'),
            onTap: () {
              Navigator.pop(context);
              _onLogoutAllDevices();
            },
          ),
          const SizedBox(height: 12),
        ],
      );
    },
  );
}

void _onLogoutThisDevice() {
  // TODO: implement Supabase signOut(current session only)
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Logout (this device) (TODO)')),
  );
}

void _onLogoutAllDevices() {
  // TODO: implement Supabase multi-session revoke via RPC/EdgeFunction
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Logout (all devices) (TODO)')),
  );
}


  @override
  Widget build(BuildContext context) {
    final background = const Color(0xFFF5EFE7);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF3C3C3C),
        title: const Text('Account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile avatar + name + email
              CircleAvatar(
                radius: 32,
                child: Text(
                  _name.isNotEmpty ? _name[0].toUpperCase() : '?',
                  style: const TextStyle(fontSize: 28),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                _email,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              if (_department != null && _department!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  _department!,
                  style:
                      const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
              if (_location != null && _location!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  _location!,
                  style:
                      const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
              const SizedBox(height: 6),
              TextButton.icon(
                onPressed: _onEditProfile,
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Edit profile'),
              ),

              const SizedBox(height: 24),

              // History header
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'History',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 8),

              // Buy / Sell / Donate cards in a row
              Row(
                children: [
                  Expanded(
                    child: _historyCard(
                      icon: Icons.shopping_cart_outlined,
                      label: 'Buy',
                      onTap: () => _openHistory(HistoryFilter.bought),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _historyCard(
                      icon: Icons.sell_outlined,
                      label: 'Sell',
                      onTap: () => _openHistory(HistoryFilter.sold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _historyCard(
                      icon: Icons.volunteer_activism_outlined,
                      label: 'Donate',
                      onTap: () => _openHistory(HistoryFilter.donated),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Account Settings',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 8),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Help & Support'),
                  onTap: _onHelp,
                ),
              ),
              const SizedBox(height: 6),
              Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
  child: ListTile(
    leading: const Icon(Icons.logout),
    title: const Text('Logout'),
    onTap: _showLogoutOptions, // 👈 UPDATED
  ),
),

            ],
          ),
        ),
      ),
    );
  }

  Widget _historyCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
