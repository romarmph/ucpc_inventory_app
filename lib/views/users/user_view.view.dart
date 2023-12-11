import 'package:flutter/material.dart';
import 'package:ucpc_inventory_management_app/exports.dart';

class UserView extends ConsumerStatefulWidget {
  const UserView({super.key, required this.user});

  final UserModel user;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserViewState();
}

class _UserViewState extends ConsumerState<UserView> {
  final _formkey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dropdownController = TextEditingController();

  String _previousName = '';
  String _previousEmail = '';
  String _previousRole = '';

  bool _isViewMode = true;

  @override
  void initState() {
    _nameController.text = widget.user.name;
    _emailController.text = widget.user.email;
    _dropdownController.text =
        widget.user.role.toString().split('.').last.capitalize;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isCurrentUser = AuthService.instance.currentUser.uid == widget.user.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isViewMode ? 'View User' : 'Edit User'),
        actions: [
          Visibility(
            visible: _isViewMode,
            child: PopupMenuButton(
              onSelected: (value) {
                if (value == 'edit') {
                  setState(() {
                    _isViewMode = false;
                    _previousName = _nameController.text;
                    _previousEmail = _emailController.text;
                    _previousRole = _dropdownController.text;
                  });
                } else {
                  if (!isCurrentUser) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.confirm,
                      title: 'Delete User',
                      text: 'Are you sure you want to delete this user?',
                      onConfirmBtnTap: () async {
                        Navigator.of(context).pop(true);
                        _showLoading();
                        try {
                          await UserDatabase.instance
                              .deleteUser(widget.user.id!);
                          _pop();
                          _showSuccess();
                        } on Exception {
                          _pop();
                          _showError('Error deleting user');
                        }
                      },
                    );
                  } else {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      title: 'Error',
                      text: 'You cannot delete your own account',
                    );
                  }
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      title: Text('Edit'),
                      leading: Icon(Icons.edit_rounded),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      title: Text('Delete'),
                      leading: Icon(Icons.delete_rounded),
                    ),
                  ),
                ];
              },
            ),
          ),
          Visibility(
            visible: !_isViewMode,
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  _isViewMode = true;
                });
                _nameController.text = _previousName;
                _emailController.text = _previousEmail;
                _dropdownController.text = _previousRole;
              },
              icon: const Icon(Icons.cancel_rounded),
              label: const Text('Cancel'),
            ),
          )
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    readOnly: _isViewMode,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please enter name';
                      }

                      if (value!.length < 3) {
                        return 'Name must be at least 3 characters';
                      }

                      return null;
                    },
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    enabled: false,
                    readOnly: _isViewMode,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please enter email';
                      }

                      return null;
                    },
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: DropdownMenu(
                      enabled: !_isViewMode,
                      controller: _dropdownController,
                      width: constraints.maxWidth - 32,
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(
                          value: UserRoles.admin,
                          label: 'Admin',
                        ),
                        DropdownMenuEntry(
                          value: UserRoles.employee,
                          label: 'Employee',
                        ),
                      ],
                      hintText: 'Select Role',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: !_isViewMode,
                    child: FilledButton(
                      onPressed: _updateAccount,
                      child: const Text('Update Account'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  void _updateAccount() async {
    final result = await QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'Update Account',
      text: 'Are you sure you want to update this account?',
      onConfirmBtnTap: () {
        Navigator.of(context).pop(true);
      },
    );

    if (result != true) {
      return;
    }

    if (_formkey.currentState!.validate()) {
      if (_dropdownController.text.isEmpty) {
        _showError(
          'Please select role',
        );
        return;
      }
      final UserModel user = UserModel(
        id: widget.user.id,
        name: _nameController.text,
        email: _emailController.text,
        role: UserRoles.values.firstWhere((element) {
          return element.toString().split('.').last ==
              _dropdownController.text.toLowerCase();
        }),
        createdAt: widget.user.createdAt,
        updatedAt: Timestamp.now(),
        createdBy: widget.user.createdBy,
        updatedBy: ref.watch(authProvider).currentUser.uid,
      );

      _showLoading();

      try {
        await UserDatabase.instance.updateUser(user);
        _pop();
        _showSuccess();
      } on Exception catch (e) {
        _pop();

        if (e.toString().contains('invalid-email')) {
          _showError('Invalid email');
          return;
        }
        if (e.toString().contains('email-already-exists')) {
          _showError('Email already in use');
          return;
        }
        if (e.toString().contains('user-already-exists')) {
          _showError('User already exists');
          return;
        }
        _showError('Error updating account');
        return;
      }

      _showSuccess();

      _pop();
    }
  }

  void _showSuccess() async {
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Success',
      text: 'account updated successfully',
      onConfirmBtnTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );
  }

  void _showError(String text) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error',
      text: text,
    );
  }

  void _showLoading() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: 'Update account',
      text: 'Please wait...',
    );
  }

  void _pop() {
    Navigator.of(context).pop();
  }
}
