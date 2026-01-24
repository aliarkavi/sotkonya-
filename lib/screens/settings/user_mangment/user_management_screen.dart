import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sotkonya/model/app_user.dart';
import 'package:sotkonya/providers/users_provider.dart';


class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<UsersProvider>().loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UsersProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المستخدمين'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: provider.setSearch,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'بحث بالاسم أو الإيميل',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          if (provider.loading)
            const LinearProgressIndicator(),

          Expanded(
            child: ListView.builder(
              itemCount: provider.users.length,
              itemBuilder: (_, i) {
                final user = provider.users[i];
                return _UserTile(user: user);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final AppUser user;

  const _UserTile({required this.user});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<UsersProvider>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage:
              user.photoUrl.isNotEmpty ? NetworkImage(user.photoUrl) : null,
          child: user.photoUrl.isEmpty
              ? Text(user.name.isNotEmpty ? user.name[0] : '?')
              : null,
        ),
        title: Text(user.name),
        subtitle: Text('${user.email}\nRole: ${user.role}'),
        isThreeLine: true,
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'admin') {
              await provider.toggleAdmin(user);
            } else if (value == 'block') {
              await provider.toggleBlock(user);
            } else if (value == 'delete') {
              await provider.deleteUser(user.id);
            }
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'admin',
              child: Text(
                user.role == 'admin'
                    ? 'إزالة صلاحية أدمن'
                    : 'جعله أدمن',
              ),
            ),
            PopupMenuItem(
              value: 'block',
              child: Text(
                user.role == 'blocked'
                    ? 'إلغاء الحظر'
                    : 'حظر المستخدم',
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text(
                'حذف المستخدم',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
