import 'package:flutter/material.dart';

class EditFieldPage extends StatefulWidget {
  final String title;
  final String initialValue;

  const EditFieldPage({
    Key? key,
    required this.title,
    required this.initialValue,
  }) : super(key: key);

  @override
  _EditFieldPageState createState() => _EditFieldPageState();
}

class _EditFieldPageState extends State<EditFieldPage> {
  late TextEditingController _controller;
  late bool _isValid;
  int _charCount = 0;
  String _selectedGender = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _charCount = widget.initialValue.length;
    _isValid = _validateInput(widget.initialValue);
    _selectedGender = widget.initialValue;

    if (widget.title == 'Gender') {
      _controller.text = '';
    }

    _controller.addListener(() {
      setState(() {
        _charCount = _controller.text.length;
        _isValid = _validateInput(_controller.text);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _validateInput(String input) {
    return input.isNotEmpty && input.length <= 30;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isValid
                ? () {
                    if (widget.title == 'Gender') {
                      Navigator.of(context).pop(_selectedGender);
                    } else {
                      Navigator.of(context).pop(_controller.text);
                    }
                  }
                : null,
            child: const Text('Save', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title == 'Gender') ...[
              const SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.male, color: _selectedGender == 'Male' ? Colors.blue : Colors.grey),
                title: Text(
                  'Male',
                  style: TextStyle(color: _selectedGender == 'Male' ? Colors.blue : Colors.black),
                ),
                trailing: Radio<String>(
                  value: 'Male',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                      _isValid = true;
                    });
                  },
                  activeColor: Colors.blue,
                ),
              ),
              ListTile(
                leading: Icon(Icons.female, color: _selectedGender == 'Female' ? Colors.blue : Colors.grey),
                title: Text(
                  'Female',
                  style: TextStyle(color: _selectedGender == 'Female' ? Colors.blue : Colors.black),
                ),
                trailing: Radio<String>(
                  value: 'Female',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                      _isValid = true;
                    });
                  },
                  activeColor: Colors.blue,
                ),
              ),
            ] else ...[
              TextField(
                controller: _controller,
                maxLength: 30,
                decoration: InputDecoration(
                  hintText: 'Enter ${widget.title.toLowerCase()}',
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: _isValid ? Colors.blue : Colors.red,
                      width: 2.0,
                    ),
                  ),
                  errorText: _isValid ? null : 'Input must be between 1 and 30 characters',
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  '$_charCount/30',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
