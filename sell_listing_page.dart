import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/services/user_manager.dart';
import 'package:flutter_application_1/services/listing_provider.dart';

class SellListingPage extends StatefulWidget {
  const SellListingPage({super.key});

  @override
  State<SellListingPage> createState() => _SellListingPageState();
}

class _SellListingPageState extends State<SellListingPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _pickupLocationController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();

  String _listingType = 'Sell'; // Sell / Rent / Lend / Donation / Share
  String? _selectedCategory;
  String? _selectedCondition;

  final List<XFile> _pickedImages = [];
  final _imagePicker = ImagePicker();

  final _categories = <String>[
    'Electronics',
    'Furniture',
    'Stationery',
    'Sports',
    'House',
    'Others',
  ];

  final _conditions = <String>[
    'New',
    'Like New',
    'Good',
    'Used',
  ];

  bool get _isDonation => _listingType == 'Donation';
  bool get _isShareEnabled => _selectedCategory == 'House';

  Future<void> _pickImage() async {
    final result = await _imagePicker.pickMultiImage();
    if (result.isNotEmpty) {
      setState(() {
        _pickedImages.addAll(result);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final imagePaths = _pickedImages.map((x) => x.path).toList();
      final provider = context.read<ListingProvider>();

      // Use provider to create listing (automatically calls refreshAll internally)
      final success = await provider.createListing(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        listingType: _listingType,
        price: _isDonation ? null : double.tryParse(_priceController.text),
        listedBy: _emailController.text.isNotEmpty ? _emailController.text : 'john@company.com',
        imagePaths: imagePaths,
      );

      if (!mounted) return;

      if (success) {
        // ✅ SUCCESS MESSAGE
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Listing sent for approval'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // ✅ RESET FORM (THIS IS CRITICAL)
        _formKey.currentState!.reset();
        _titleController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _pickupLocationController.clear();
        _contactController.clear();

        setState(() {
          _listingType = 'Sell';
          _selectedCategory = null;
          _selectedCondition = null;
          _pickedImages.clear();
        });

        // ✅ NO NAVIGATION - User stays on Sell page
        // Sell page is already inside MainNavigation
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create listing'),
            backgroundColor: Colors.red,
          ),
        );
      }

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


    Widget _buildListingTypeChip(String value) {
    final bool selected = _listingType == value;
    final bool enabled = value != 'Share' || _isShareEnabled;
    final theme = Theme.of(context);
    
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: ChoiceChip(
        label: Text(
          value,
          style: TextStyle(
            color: selected ? theme.colorScheme.onPrimary : Colors.black87,
          ),
        ),
        selected: selected,
        onSelected: enabled ? (_) {
          setState(() {
            _listingType = value;
            if (_isDonation) {
              _priceController.clear();
            }
          });
        } : null,
        selectedColor: theme.colorScheme.primary,
        backgroundColor: theme.chipTheme.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: selected ? theme.colorScheme.primary : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _pickupLocationController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Pre-fill email from user manager
    _emailController.text = UserManager.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell an Item'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Enter a title' : null,
                ),
                const SizedBox(height: 12),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Enter a description'
                      : null,
                ),
                const SizedBox(height: 16),

                // Category dropdown (moved before Listing Type)
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  menuMaxHeight: 320,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: _categories
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(c),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedCategory = val;
                      // Reset listing type if Share was selected and House is deselected
                      if (_listingType == 'Share' && val != 'House') {
                        _listingType = 'Sell';
                      }
                    });
                  },
                  validator: (v) =>
                      v == null ? 'Please select a category' : null,
                ),
                const SizedBox(height: 16),

                // Listing Type
                const Text(
                  'Listing Type',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildListingTypeChip('Sell'),
                      _buildListingTypeChip('Rent'),
                      _buildListingTypeChip('Lend'),
                      _buildListingTypeChip('Donation'),
                      _buildListingTypeChip('Share'),
                    ],
                  ),
                ),
                if (_listingType == 'Share' && _isShareEnabled)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Share option is for house sharing/roommate listings',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                // Price (disabled for Donation)
                TextFormField(
                  controller: _priceController,
                  enabled: !_isDonation,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText:
                        _isDonation ? 'Price disabled for donations' : null,
                  ),
                  validator: (v) {
                    if (_isDonation) return null;
                    if (v == null || v.trim().isEmpty) {
                      return 'Enter price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Condition
                DropdownButtonFormField<String>(
                  value: _selectedCondition,
                  decoration: InputDecoration(
                    labelText: 'Condition',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: _conditions
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(c),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedCondition = val),
                  validator: (v) =>
                      v == null ? 'Please select a condition' : null,
                ),
                const SizedBox(height: 12),

                // Pickup location
                TextFormField(
                  controller: _pickupLocationController,
                  decoration: InputDecoration(
                    labelText: 'Pickup Location (optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Contact number
                TextFormField(
                  controller: _contactController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Contact Number',
                    hintText: '10-digit mobile number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter contact number';
                    final digits = v.trim();
                    if (digits.length != 10) return 'Contact number must be 10 digits';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Account email (auto-filled)
                TextFormField(
                  controller: _emailController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Account Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Images
                const Text(
                  'Images',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._pickedImages.map(
                      (img) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(img.path),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: _pickImage,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: const Icon(Icons.add_a_photo_outlined),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _submit,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Post Listing'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}