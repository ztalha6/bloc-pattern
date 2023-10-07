import 'package:bloc_pattren_sample/bloc/app_bloc.dart';
import 'package:bloc_pattren_sample/bloc/app_events.dart';
import 'package:bloc_pattren_sample/dialog/delete_account_dialog.dart';
import 'package:bloc_pattren_sample/dialog/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum MenuAction { logout, deleteAccount }

class MainPopupMenuButton extends StatelessWidget {
  const MainPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      onSelected: (value) {
        _handleAction(value, context);
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: MenuAction.logout,
            child: Text('Logout'),
          ),
          const PopupMenuItem(
            value: MenuAction.deleteAccount,
            child: Text('Delete Account'),
          ),
        ];
      },
    );
  }

  Future<void> _handleAction(MenuAction value, BuildContext context) async {
    switch (value) {
      case MenuAction.logout:
        final shouldLogout = await showLogoutDialog(context);
        if (shouldLogout) {
          context.read<AppBloc>().add(const AppEventLogout());
        }
        break;
      case MenuAction.deleteAccount:
        final shouldLogout = await showDeleteAccountDialog(context);
        if (shouldLogout) {
          context.read<AppBloc>().add(const AppEventDeleteAccount());
        }
        break;
      default:
    }
  }
}
