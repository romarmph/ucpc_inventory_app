import 'package:flutter/material.dart';
import 'package:ucpc_inventory_management_app/exports.dart';

class UserAddForm extends ConsumerStatefulWidget {
  const UserAddForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserAddFormState();
}

class _UserAddFormState extends ConsumerState<UserAddForm> {
  final _formkey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dropdownController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
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
                  const SizedBox(height: 12),
                  TextFormField(
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please enter password';
                      }

                      if (value!.length < 8) {
                        return 'Password must be at least 8 characters';
                      }

                      return null;
                    },
                    controller: _passwordController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        icon: Icon(
                          _isObscure
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please confirm password';
                      }

                      if (value != _passwordController.text) {
                        return 'Password does not match';
                      }

                      return null;
                    },
                    controller: _confirmPasswordController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        icon: Icon(
                          _isObscure
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _addUser,
                    child: const Text('Add User'),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  void _addUser() async {
    final result = await QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'Add User',
      text: 'Are you sure you want to add this user?',
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
        name: _nameController.text,
        email: _emailController.text,
        role: UserRoles.values.firstWhere((element) {
          return element.toString().split('.').last ==
              _dropdownController.text.toLowerCase();
        }),
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        createdBy: ref.watch(authProvider).currentUser.uid,
        updatedBy: ref.watch(authProvider).currentUser.uid,
      );

      _showLoading();

      try {
        await UserDatabase.instance.addUser(user, _passwordController.text);
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
        _showError('Error adding user');
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
      text: 'User added successfully',
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
      title: 'Adding User',
      text: 'Please wait...',
    );
  }

  void _pop() {
    Navigator.of(context).pop();
  }
}
