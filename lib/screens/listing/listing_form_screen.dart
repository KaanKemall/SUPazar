import 'package:flutter/material.dart';

import '../../data/listing_store.dart';
import '../../data/sample_data.dart';
import '../../models/category.dart';
import '../../models/listing.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/formatters.dart';
import '../../utils/validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/photo_picker_row.dart';
import '../../widgets/responsive_center.dart';

/// Screen 5 / 5b: Post Listing and Edit Listing share this form.
/// With a [listingId] it edits that listing, otherwise it creates a new one.
class ListingFormScreen extends StatefulWidget {
  const ListingFormScreen({super.key, this.listingId, this.onPublished});

  final String? listingId;

  /// Called after a new listing is published (used by the Post tab).
  final VoidCallback? onPublished;

  @override
  State<ListingFormScreen> createState() => _ListingFormScreenState();
}

class _ListingFormScreenState extends State<ListingFormScreen> {
  final _store = ListingStore.instance;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  ListingCategory? _category;
  List<String> _photos = [];
  Listing? _editing;

  bool get _isEdit => _editing != null;

  @override
  void initState() {
    super.initState();
    if (widget.listingId != null) {
      _editing = _store.findById(widget.listingId!);
      final l = _editing;
      if (l != null) {
        _titleController.text = l.title;
        _descriptionController.text = l.description;
        _priceController.text = l.price.toString();
        _category = l.category;
        _photos = [...l.imageUrls];
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _addPhoto() {
    final next = SampleData.demoPhotos.firstWhere(
      (p) => !_photos.contains(p),
      orElse: () => SampleData.demoPhotos.first,
    );
    setState(() => _photos.add(next));
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _titleController.clear();
    _descriptionController.clear();
    _priceController.clear();
    setState(() {
      _category = null;
      _photos = [];
    });
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final price = int.parse(_priceController.text.trim());
    final confirmed = await showConfirmDialog(
      context,
      title: _isEdit ? 'Save changes?' : 'Publish listing?',
      message: _isEdit
          ? 'Your changes to "$title" will be visible to all students.'
          : '"$title" for ${Formatters.price(price)} will be visible to all students.',
      confirmLabel: _isEdit ? 'Save' : 'Publish',
    );
    if (!confirmed || !mounted) return;

    if (_isEdit) {
      _store.update(
        _editing!.copyWith(
          title: title,
          description: _descriptionController.text.trim(),
          price: price,
          category: _category,
          imageUrls: _photos,
        ),
      );
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Listing updated')));
    } else {
      _store.add(
        title: title,
        description: _descriptionController.text.trim(),
        price: price,
        category: _category!,
        imageUrls: _photos,
      );
      _resetForm();
      widget.onPublished?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.listingId != null && _editing == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('This listing was removed.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: _isEdit,
        title: Text(_isEdit ? 'Edit listing' : 'Post a listing'),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: ResponsiveCenter(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PhotoPickerRow(
                  photos: _photos,
                  onAdd: _addPhoto,
                  onRemove: (i) => setState(() => _photos.removeAt(i)),
                ),
                AppTextField(
                  label: 'Title',
                  hint: 'e.g. Calculus textbook',
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  validator: Validators.title,
                  maxLength: 60,
                ),
                AppTextField(
                  label: 'Description',
                  hint: 'Describe the item…',
                  controller: _descriptionController,
                  maxLines: 4,
                  maxLength: 500,
                ),
                AppTextField(
                  label: 'Price (₺)',
                  hint: '250',
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  validator: Validators.price,
                  prefixIcon: Icons.sell_outlined,
                ),
                const Text('Category', style: AppTextStyles.sectionLabel),
                AppSpacing.gapXs,
                DropdownButtonFormField<ListingCategory>(
                  initialValue: _category,
                  isExpanded: true,
                  hint: const Text('Choose a category'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (v) => v == null ? 'Category is required' : null,
                  items: [
                    for (final c in ListingCategory.values)
                      DropdownMenuItem(
                        value: c,
                        child: Row(
                          children: [
                            Icon(c.icon, size: 20),
                            AppSpacing.gapSm,
                            Text(c.label),
                          ],
                        ),
                      ),
                  ],
                  onChanged: (v) => setState(() => _category = v),
                ),
                AppSpacing.gapLg,
                FilledButton(
                  onPressed: _submit,
                  child: Text(_isEdit ? 'Save' : 'Publish'),
                ),
                AppSpacing.gapMd,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
