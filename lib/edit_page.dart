import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'edit_field.dart';
import 'dart:io';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  XFile? _selectedAvatarImage;
  final List<String> _photoUrls = [];

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
        title: const Text(
          'Edit',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Avatar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      _showAvatarImageSheet(context);
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: _selectedAvatarImage != null ? FileImage(File(_selectedAvatarImage!.path)) : const NetworkImage('https://via.placeholder.com/150'),
                        ),
                        const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildPhotoAlbumSection(context),
              const SizedBox(height: 20),
              _buildEditableField(
                context: context,
                title: 'Nickname',
                value: 'RL RONY',
                onTap: () => _navigateToEditFieldPage(context, 'Nickname', 'RL RONY'),
              ),
              _buildEditableField(
                context: context,
                title: 'Gender',
                value: 'Male',
                onTap: () => _navigateToEditFieldPage(context, 'Gender', 'Male'),
              ),
              _buildEditableField(
                context: context,
                title: 'Birthday',
                value: '1996-01-01',
                onTap: () {
                  _showBirthdayPicker(context);
                },
              ),
              _buildEditableField(
                context: context,
                title: 'Country/Region',
                value: 'Bangladesh',
              ),
              _buildEditableField(
                context: context,
                title: 'Signature',
                value: 'I Love Bobbo',
                onTap: () => _navigateToEditFieldPage(context, 'Signature', 'I Love Bobbo'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAvatarImageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ImageSheet(
          onImagePicked: (XFile image) {
            setState(() {
              _selectedAvatarImage = image;
            });
          },
        );
      },
    );
  }

  void _showAlbumImageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ImageSheet(
          onImagePicked: (XFile image) {
            setState(() {
              _photoUrls.insert(0, image.path);
              if (_photoUrls.length > 5) {
                _photoUrls.removeLast();
              }
            });
          },
        );
      },
    );
  }

  Widget _buildEditableField({
    required BuildContext context,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.normal),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
              ],
            ),
            onTap: onTap,
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoAlbumSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Album',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        const Text(
          'Click to change or delete photos. Drag photo to change order.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  _showAlbumImageSheet(context);
                },
                child: Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              ..._buildPhotoThumbnails(),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPhotoThumbnails() {
    return _photoUrls.map((url) => _buildPhotoThumbnail(url)).toList();
  }

  Widget _buildPhotoThumbnail(String url) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: url.isNotEmpty && File(url).existsSync()
          ? Image.file(
              File(url),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            )
          : Container(
              width: 80,
              height: 80,
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image, color: Colors.white),
            ),
    );
  }

  void _showBirthdayPicker(BuildContext context) {
    DateTime initialDate = DateTime(1996, 1, 1); // Example initial date
    final FixedExtentScrollController dayController = FixedExtentScrollController(initialItem: initialDate.day - 1);
    final FixedExtentScrollController monthController = FixedExtentScrollController(initialItem: initialDate.month - 1);
    final FixedExtentScrollController yearController = FixedExtentScrollController(initialItem: initialDate.year - 1920);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            height: 300,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, -1),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel', style: TextStyle(color: Colors.blue, fontSize: 14)),
                      ),
                      const Text(
                        'Choose Date',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Confirm', style: TextStyle(color: Colors.blue, fontSize: 14)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildListWheelScrollView(
                            controller: dayController,
                            itemCount: 31,
                            onSelectedItemChanged: (index) {},
                            label: 'Day',
                          ),
                          _buildListWheelScrollView(
                            controller: monthController,
                            itemCount: 12,
                            onSelectedItemChanged: (index) {},
                            label: 'Month',
                          ),
                          _buildListWheelScrollView(
                            controller: yearController,
                            itemCount: 101,
                            onSelectedItemChanged: (index) {},
                            label: 'Year',
                          ),
                        ],
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 50,
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.blue, width: 2),
                                bottom: BorderSide(color: Colors.blue, width: 2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListWheelScrollView({
    required FixedExtentScrollController controller,
    required int itemCount,
    required void Function(int) onSelectedItemChanged,
    required String label,
  }) {
    return Expanded(
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 50,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onSelectedItemChanged,
        childDelegate: ListWheelChildLoopingListDelegate(
          children: List<Widget>.generate(itemCount, (index) {
            return Container(
              alignment: Alignment.center,
              child: Text(
                label == 'Day'
                    ? '${(index % 31) + 1}'
                    : label == 'Month'
                        ? '${(index % 12) + 1}'
                        : '${(index % 101) + 1920}',
                style: const TextStyle(fontSize: 16),
              ),
            );
          }),
        ),
      ),
    );
  }

  void _navigateToEditFieldPage(BuildContext context, String title, String initialValue) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditFieldPage(title: title, initialValue: initialValue),
      ),
    );
  }
}

class ImageSheet extends StatelessWidget {
  final void Function(XFile) onImagePicked; // Define the callback

  ImageSheet({super.key, required this.onImagePicked});

  final ImagePicker _picker = ImagePicker();

  void _openCamera(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      onImagePicked(pickedFile); // Call the callback with the picked image
    }
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      onImagePicked(pickedFile); // Call the callback with the picked image
    }
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            spreadRadius: 5.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Choose an option',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          ListTile(
            leading: const Icon(Icons.camera_alt, color: Colors.blueAccent),
            title: const Text('Camera'),
            onTap: () => _openCamera(context),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: Colors.green),
            title: const Text('Gallery'),
            onTap: () => _openGallery(context),
          ),
          ListTile(
            leading: const Icon(Icons.cancel, color: Colors.redAccent),
            title: const Text('Cancel'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    return pickedFile;
  }

  Future<XFile?> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }
}
