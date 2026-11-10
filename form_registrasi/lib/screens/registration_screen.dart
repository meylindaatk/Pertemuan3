import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk input teks
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController(); // Latihan 1
  final TextEditingController _dobController = TextEditingController();   // Latihan 2
  final TextEditingController _passwordController = TextEditingController();

  // State variabel (Sudah dipastikan diinisialisasi nilai default false, bukan null)
  String? _selectedGender; // Latihan 3
  DateTime? _selectedDate; // Latihan 2
  bool _agreedToTerms = false; // Latihan 4 (Dipastikan boolean non-null)
  bool _termsError = false; // Latihan 4: Indikator error checkbox

  // State untuk kekuatan password
  double _passwordStrength = 0.0; // Latihan 5
  String _passwordStrengthText = '';
  Color _passwordStrengthColor = Colors.grey;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Latihan 2: Memilih Tanggal Lahir
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  // Latihan 5: Evaluasi Kekuatan Password
  void _checkPasswordStrength(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordStrength = 0.0;
        _passwordStrengthText = '';
        _passwordStrengthColor = Colors.grey;
      } else if (value.length < 8) {
        _passwordStrength = 0.33;
        _passwordStrengthText = 'Lemah (< 8 karakter)';
        _passwordStrengthColor = Colors.red;
      } else {
        bool hasLetters = value.contains(RegExp(r'[a-zA-Z]'));
        bool hasDigits = value.contains(RegExp(r'[0-9]'));
        bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
        bool hasLowercase = value.contains(RegExp(r'[a-z]'));
        bool hasSpecialCharacters =
            value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

        if (hasUppercase && hasLowercase && hasDigits && hasSpecialCharacters) {
          _passwordStrength = 1.0;
          _passwordStrengthText = 'Kuat';
          _passwordStrengthColor = Colors.green;
        } else if (hasLetters && hasDigits) {
          _passwordStrength = 0.66;
          _passwordStrengthText = 'Sedang';
          _passwordStrengthColor = Colors.orange;
        } else {
          _passwordStrength = 0.33;
          _passwordStrengthText = 'Lemah';
          _passwordStrengthColor = Colors.red;
        }
      }
    });
  }

  // Submit Form Validation & Action
  void _submitForm() {
    // Validasi checkbox Syarat & Ketentuan (Latihan 4)
    setState(() {
      _termsError = !_agreedToTerms;
    });

    final isFormValid = _formKey.currentState!.validate();

    if (isFormValid && _agreedToTerms) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registrasi Berhasil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nama: ${_nameController.text}'),
              Text('Email: ${_emailController.text}'),
              Text('No. Telepon: ${_phoneController.text}'),
              Text('Tanggal Lahir: ${_dobController.text}'),
              Text('Jenis Kelamin: $_selectedGender'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Registrasi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Field Nama
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Field Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email wajib diisi';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Latihan 1: Field Nomor Telepon
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nomor telepon wajib diisi';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Hanya boleh berisi angka';
                  }
                  if (value.length < 10 || value.length > 13) {
                    return 'Nomor telepon harus 10 - 13 digit';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Latihan 2: Field Tanggal Lahir (Show DatePicker)
              TextFormField(
                controller: _dobController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: const InputDecoration(
                  labelText: 'Tanggal Lahir',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal lahir wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Latihan 3: Dropdown Jenis Kelamin
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Jenis Kelamin',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.people),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Laki-laki',
                    child: Text('Laki-laki'),
                  ),
                  DropdownMenuItem(
                    value: 'Perempuan',
                    child: Text('Perempuan'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jenis kelamin wajib dipilih';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Field Password
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                onChanged: _checkPasswordStrength, // Latihan 5
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password wajib diisi';
                  }
                  if (value.length < 8) {
                    return 'Password minimal 8 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),

              // Latihan 5: Indikator Kekuatan Password
              if (_passwordController.text.isNotEmpty) ...[
                LinearProgressIndicator(
                  value: _passwordStrength,
                  backgroundColor: Colors.grey[300],
                  color: _passwordStrengthColor,
                  minHeight: 6,
                ),
                const SizedBox(height: 4),
                Text(
                  'Kekuatan Password: $_passwordStrengthText',
                  style: TextStyle(
                    color: _passwordStrengthColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              const SizedBox(height: 16),

              // Latihan 4: Checkbox Syarat & Ketentuan (Perbaikan Null Safety)
              CheckboxListTile(
                title: const Text('Saya setuju dengan Syarat & Ketentuan'),
                value: _agreedToTerms, // Menjamin nilai selalu non-null (true/false)
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                onChanged: (value) {
                  setState(() {
                    _agreedToTerms = value ?? false;
                    if (_agreedToTerms) _termsError = false;
                  });
                },
              ),
              if (_termsError)
                const Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text(
                    'Anda harus menyetujui syarat & ketentuan',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 24),

              // Tombol Submit
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text(
                    'DAFTAR',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}