import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../core/auth/current_user_provider.dart';

class MainScaffold extends ConsumerWidget {
  const MainScaffold({super.key, required this.child, required this.location});

  final Widget child;
  final String location;

  static const _baseTabs = [
    (path: '/quotes',    icon: Symbols.description, label: 'Teklifler'),
    (path: '/customers', icon: Symbols.people,       label: 'Müşteriler'),
  ];

  static const _adminTab =
      (path: '/admin', icon: Symbols.admin_panel_settings, label: 'Yönetim');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(isAdminProvider).valueOrNull ?? false;
    final tabs    = [..._baseTabs, if (isAdmin) _adminTab];

    int currentIndex = 0;
    for (var i = 0; i < tabs.length; i++) {
      if (location.startsWith(tabs[i].path)) {
        currentIndex = i;
        break;
      }
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (i) => context.go(tabs[i].path),
          destinations: tabs
              .map((t) => NavigationDestination(
                    icon: Icon(t.icon),
                    selectedIcon: Icon(t.icon, fill: 1),
                    label: t.label,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
