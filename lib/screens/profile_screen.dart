import 'package:flutter/cupertino.dart';

import '../models/location_option.dart';
import '../models/profile_update_request.dart';
import '../models/student_profile.dart';
import '../services/api_service.dart';
import '../services/auth_store.dart';
import '../theme/app_colors.dart';
import '../widgets/auth_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.authStore});

  final AuthStore authStore;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _fields;

  List<LocationOption> _provinces = const [];
  List<LocationOption> _currentDistricts = const [];
  List<LocationOption> _currentCommunes = const [];
  List<LocationOption> _currentVillages = const [];
  List<LocationOption> _permanentDistricts = const [];
  List<LocationOption> _permanentCommunes = const [];
  List<LocationOption> _permanentVillages = const [];

  int? _currentProvinceId;
  int? _currentDistrictId;
  int? _currentCommuneId;
  int? _currentVillageId;
  int? _permanentProvinceId;
  int? _permanentDistrictId;
  int? _permanentCommuneId;
  int? _permanentVillageId;
  int? _educationProvinceId;
  String? _gender;
  DateTime? _dateOfBirth;
  String? _error;
  bool _loadingLocations = true;
  bool _changingAddress = false;
  bool _saving = false;
  bool _validationAttempted = false;

  StudentProfile? get _profile => widget.authStore.profile;

  @override
  void initState() {
    super.initState();
    final profile = _profile;
    _fields = {
      'nameKm': _controller(profile?.nameKm),
      'nameEn': _controller(profile?.nameEn),
      'nationality': _controller(profile?.nationality),
      'email': _controller(profile?.email),
      'currentHouse': _controller(profile?.currentHouse),
      'currentStreet': _controller(profile?.currentStreet),
      'permanentHouse': _controller(profile?.permanentHouse),
      'permanentStreet': _controller(profile?.permanentStreet),
      'fatherName': _controller(profile?.fatherName),
      'fatherOccupation': _controller(profile?.fatherOccupation),
      'fatherPhone': _controller(profile?.fatherPhone),
      'motherName': _controller(profile?.motherName),
      'motherOccupation': _controller(profile?.motherOccupation),
      'motherPhone': _controller(profile?.motherPhone),
      'emergencyName': _controller(profile?.emergencyName),
      'emergencyPhone': _controller(profile?.emergencyPhone),
      'highSchool': _controller(profile?.highSchool),
      'graduationYear': _controller(profile?.graduationYear?.toString()),
    };
    _gender = profile?.gender;
    _dateOfBirth = DateTime.tryParse(profile?.dateOfBirth ?? '');
    _currentProvinceId = profile?.currentProvinceId;
    _currentDistrictId = profile?.currentDistrictId;
    _currentCommuneId = profile?.currentCommuneId;
    _currentVillageId = profile?.currentVillageId;
    _permanentProvinceId = profile?.permanentProvinceId;
    _permanentDistrictId = profile?.permanentDistrictId;
    _permanentCommuneId = profile?.permanentCommuneId;
    _permanentVillageId = profile?.permanentVillageId;
    _educationProvinceId = profile?.educationProvinceId;
    _loadLocations();
  }

  @override
  void dispose() {
    for (final controller in _fields.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _controller(String? value) {
    return TextEditingController(text: value ?? '');
  }

  Future<void> _loadLocations() async {
    try {
      final provinces = await widget.authStore.provinces();
      var currentDistricts = <LocationOption>[];
      var currentCommunes = <LocationOption>[];
      var currentVillages = <LocationOption>[];
      var permanentDistricts = <LocationOption>[];
      var permanentCommunes = <LocationOption>[];
      var permanentVillages = <LocationOption>[];

      if (_currentProvinceId != null) {
        currentDistricts = await widget.authStore.districts(
          _currentProvinceId!,
        );
      }
      if (_currentDistrictId != null) {
        currentCommunes = await widget.authStore.communes(_currentDistrictId!);
      }
      if (_currentCommuneId != null) {
        currentVillages = await widget.authStore.villages(_currentCommuneId!);
      }
      if (_permanentProvinceId != null) {
        permanentDistricts = await widget.authStore.districts(
          _permanentProvinceId!,
        );
      }
      if (_permanentDistrictId != null) {
        permanentCommunes = await widget.authStore.communes(
          _permanentDistrictId!,
        );
      }
      if (_permanentCommuneId != null) {
        permanentVillages = await widget.authStore.villages(
          _permanentCommuneId!,
        );
      }

      if (!mounted) return;
      setState(() {
        _provinces = provinces;
        _currentDistricts = currentDistricts;
        _currentCommunes = currentCommunes;
        _currentVillages = currentVillages;
        _permanentDistricts = permanentDistricts;
        _permanentCommunes = permanentCommunes;
        _permanentVillages = permanentVillages;
        _loadingLocations = false;
      });
    } on ApiException catch (error) {
      _finishLocationLoad(error.message);
    } catch (_) {
      _finishLocationLoad('Could not load address choices. Try again.');
    }
  }

  void _finishLocationLoad(String message) {
    if (!mounted) return;
    setState(() {
      _error = message;
      _loadingLocations = false;
    });
  }

  Future<void> _chooseCurrentProvince() async {
    final selected = await _pickLocation(
      title: 'Current province',
      options: _provinces,
      selectedId: _currentProvinceId,
    );
    if (selected == null || selected.id == _currentProvinceId) return;
    setState(() {
      _currentProvinceId = selected.id;
      _currentDistrictId = null;
      _currentCommuneId = null;
      _currentVillageId = null;
      _currentDistricts = const [];
      _currentCommunes = const [];
      _currentVillages = const [];
    });
    await _loadAddressLevel(
      () => widget.authStore.districts(selected.id),
      (items) => _currentDistricts = items,
    );
  }

  Future<void> _chooseCurrentDistrict() async {
    final selected = await _pickLocation(
      title: 'Current district',
      options: _currentDistricts,
      selectedId: _currentDistrictId,
    );
    if (selected == null || selected.id == _currentDistrictId) return;
    setState(() {
      _currentDistrictId = selected.id;
      _currentCommuneId = null;
      _currentVillageId = null;
      _currentCommunes = const [];
      _currentVillages = const [];
    });
    await _loadAddressLevel(
      () => widget.authStore.communes(selected.id),
      (items) => _currentCommunes = items,
    );
  }

  Future<void> _chooseCurrentCommune() async {
    final selected = await _pickLocation(
      title: 'Current commune',
      options: _currentCommunes,
      selectedId: _currentCommuneId,
    );
    if (selected == null || selected.id == _currentCommuneId) return;
    setState(() {
      _currentCommuneId = selected.id;
      _currentVillageId = null;
      _currentVillages = const [];
    });
    await _loadAddressLevel(
      () => widget.authStore.villages(selected.id),
      (items) => _currentVillages = items,
    );
  }

  Future<void> _choosePermanentProvince() async {
    final selected = await _pickLocation(
      title: 'Permanent province',
      options: _provinces,
      selectedId: _permanentProvinceId,
    );
    if (selected == null || selected.id == _permanentProvinceId) return;
    setState(() {
      _permanentProvinceId = selected.id;
      _permanentDistrictId = null;
      _permanentCommuneId = null;
      _permanentVillageId = null;
      _permanentDistricts = const [];
      _permanentCommunes = const [];
      _permanentVillages = const [];
    });
    await _loadAddressLevel(
      () => widget.authStore.districts(selected.id),
      (items) => _permanentDistricts = items,
    );
  }

  Future<void> _choosePermanentDistrict() async {
    final selected = await _pickLocation(
      title: 'Permanent district',
      options: _permanentDistricts,
      selectedId: _permanentDistrictId,
    );
    if (selected == null || selected.id == _permanentDistrictId) return;
    setState(() {
      _permanentDistrictId = selected.id;
      _permanentCommuneId = null;
      _permanentVillageId = null;
      _permanentCommunes = const [];
      _permanentVillages = const [];
    });
    await _loadAddressLevel(
      () => widget.authStore.communes(selected.id),
      (items) => _permanentCommunes = items,
    );
  }

  Future<void> _choosePermanentCommune() async {
    final selected = await _pickLocation(
      title: 'Permanent commune',
      options: _permanentCommunes,
      selectedId: _permanentCommuneId,
    );
    if (selected == null || selected.id == _permanentCommuneId) return;
    setState(() {
      _permanentCommuneId = selected.id;
      _permanentVillageId = null;
      _permanentVillages = const [];
    });
    await _loadAddressLevel(
      () => widget.authStore.villages(selected.id),
      (items) => _permanentVillages = items,
    );
  }

  Future<void> _loadAddressLevel(
    Future<List<LocationOption>> Function() request,
    void Function(List<LocationOption>) apply,
  ) async {
    setState(() {
      _changingAddress = true;
      _error = null;
    });
    try {
      final items = await request();
      if (!mounted) return;
      setState(() => apply(items));
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Could not load address choices. Try again.');
      }
    } finally {
      if (mounted) setState(() => _changingAddress = false);
    }
  }

  Future<LocationOption?> _pickLocation({
    required String title,
    required List<LocationOption> options,
    required int? selectedId,
  }) async {
    if (options.isEmpty) return null;
    var index = options.indexWhere((item) => item.id == selectedId);
    if (index < 0) index = 0;
    var selected = options[index];
    final scrollController = FixedExtentScrollController(initialItem: index);

    final result = await showCupertinoModalPopup<LocationOption>(
      context: context,
      builder: (context) => Container(
        height: 330,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              SizedBox(
                height: 52,
                child: Row(
                  children: [
                    CupertinoButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    Expanded(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    CupertinoButton(
                      onPressed: () => Navigator.pop(context, selected),
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  scrollController: scrollController,
                  itemExtent: 44,
                  onSelectedItemChanged: (value) => selected = options[value],
                  children: [
                    for (final option in options)
                      Center(
                        child: Text(
                          option.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    scrollController.dispose();
    return result;
  }

  Future<void> _chooseDateOfBirth() async {
    var selected = _dateOfBirth ?? DateTime(2005, 1, 1);
    final now = DateTime.now();
    if (!selected.isBefore(now)) {
      selected = DateTime(now.year - 1, now.month, now.day);
    }

    final result = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (context) => Container(
        height: 330,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              SizedBox(
                height: 52,
                child: Row(
                  children: [
                    CupertinoButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const Expanded(
                      child: Text(
                        'Date of birth',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    CupertinoButton(
                      onPressed: () => Navigator.pop(context, selected),
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: selected,
                  minimumDate: DateTime(1900),
                  maximumDate: now,
                  onDateTimeChanged: (value) => selected = value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (result != null && mounted) setState(() => _dateOfBirth = result);
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    final formIsValid = _formKey.currentState?.validate() ?? false;
    final addressesAreValid = [
      _currentProvinceId,
      _currentDistrictId,
      _currentCommuneId,
      _currentVillageId,
      _permanentProvinceId,
      _permanentDistrictId,
      _permanentCommuneId,
      _permanentVillageId,
    ].every((value) => value != null);

    setState(() => _validationAttempted = true);
    if (!formIsValid || !addressesAreValid || _gender == null) {
      setState(() => _error = 'Complete all fields marked Required.');
      return;
    }

    final graduationYear = int.tryParse(_fields['graduationYear']!.text.trim());
    setState(() {
      _saving = true;
      _error = null;
    });

    final success = await widget.authStore.updateProfile(
      ProfileUpdateRequest(
        nameKm: _fields['nameKm']!.text,
        nameEn: _fields['nameEn']!.text,
        gender: _gender!,
        emergencyName: _fields['emergencyName']!.text,
        emergencyPhone: _fields['emergencyPhone']!.text,
        currentProvinceId: _currentProvinceId!,
        currentDistrictId: _currentDistrictId!,
        currentCommuneId: _currentCommuneId!,
        currentVillageId: _currentVillageId!,
        permanentProvinceId: _permanentProvinceId!,
        permanentDistrictId: _permanentDistrictId!,
        permanentCommuneId: _permanentCommuneId!,
        permanentVillageId: _permanentVillageId!,
        dateOfBirth: _formatDate(_dateOfBirth),
        nationality: _fields['nationality']!.text,
        email: _fields['email']!.text,
        currentHouse: _fields['currentHouse']!.text,
        currentStreet: _fields['currentStreet']!.text,
        permanentHouse: _fields['permanentHouse']!.text,
        permanentStreet: _fields['permanentStreet']!.text,
        fatherName: _fields['fatherName']!.text,
        fatherOccupation: _fields['fatherOccupation']!.text,
        fatherPhone: _fields['fatherPhone']!.text,
        motherName: _fields['motherName']!.text,
        motherOccupation: _fields['motherOccupation']!.text,
        motherPhone: _fields['motherPhone']!.text,
        highSchool: _fields['highSchool']!.text,
        graduationYear: graduationYear,
        educationProvinceId: _educationProvinceId,
      ),
    );

    if (!mounted) return;
    setState(() {
      _saving = false;
      _error = success ? null : widget.authStore.errorMessage;
    });
    if (!success) return;

    await showCupertinoDialog<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Profile saved'),
        content: const Text('Your student information has been updated.'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  String? _required(String? value) {
    return value == null || value.trim().isEmpty ? 'Required' : null;
  }

  String? _emailValidator(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return null;
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
        ? null
        : 'Enter a valid email';
  }

  String? _yearValidator(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final year = int.tryParse(text);
    if (year == null || year < 1900 || year > DateTime.now().year) {
      return 'Use a year from 1900 to ${DateTime.now().year}';
    }
    return null;
  }

  String? _formatDate(DateTime? value) {
    if (value == null) return null;
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }

  String? _locationName(List<LocationOption> options, int? id) {
    if (id == null) return null;
    for (final option in options) {
      if (option.id == id) return option.name;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final account = widget.authStore.account!;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Student information'),
        backgroundColor: Color(0xF2F7F8FC),
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: _validationAttempted
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.only(top: 12, bottom: 36),
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Text(
                  'Enter your details below. Fields marked Required must be completed before your student ID is assigned.',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                  child: ErrorBanner(message: _error!),
                ),
              CupertinoFormSection.insetGrouped(
                header: const Text('PERSONAL INFORMATION'),
                children: [
                  _TextRow(
                    label: 'Khmer name',
                    controller: _fields['nameKm']!,
                    placeholder: 'Required',
                    validator: _required,
                  ),
                  _TextRow(
                    label: 'English name',
                    controller: _fields['nameEn']!,
                    placeholder: 'Required',
                    validator: _required,
                  ),
                  _ReadOnlyRow(
                    label: 'Student ID',
                    value: account.studentId ?? 'Assigned after saving',
                  ),
                  _ReadOnlyRow(label: 'Phone', value: account.phone),
                  _ValueRow(
                    label: 'Date of birth',
                    value: _formatDate(_dateOfBirth),
                    placeholder: 'Optional',
                    onPressed: _chooseDateOfBirth,
                  ),
                  CupertinoFormRow(
                    prefix: const SizedBox(width: 118, child: Text('Gender')),
                    error: _validationAttempted && _gender == null
                        ? const Text('Required')
                        : null,
                    child: CupertinoSlidingSegmentedControl<String>(
                      groupValue: _gender,
                      children: const {
                        'ប្រុស': Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('Male'),
                        ),
                        'ស្រី': Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('Female'),
                        ),
                      },
                      onValueChanged: (value) =>
                          setState(() => _gender = value),
                    ),
                  ),
                  _TextRow(
                    label: 'Nationality',
                    controller: _fields['nationality']!,
                    placeholder: 'Optional',
                  ),
                  _TextRow(
                    label: 'Email',
                    controller: _fields['email']!,
                    placeholder: 'Optional',
                    keyboardType: TextInputType.emailAddress,
                    validator: _emailValidator,
                  ),
                ],
              ),
              if (_loadingLocations)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CupertinoActivityIndicator()),
                )
              else ...[
                CupertinoFormSection.insetGrouped(
                  header: const Text('CURRENT ADDRESS'),
                  children: [
                    _ValueRow(
                      label: 'Province',
                      value: _locationName(_provinces, _currentProvinceId),
                      placeholder: 'Required',
                      hasError:
                          _validationAttempted && _currentProvinceId == null,
                      onPressed: _changingAddress
                          ? null
                          : _chooseCurrentProvince,
                    ),
                    _ValueRow(
                      label: 'District',
                      value: _locationName(
                        _currentDistricts,
                        _currentDistrictId,
                      ),
                      placeholder: 'Required',
                      hasError:
                          _validationAttempted && _currentDistrictId == null,
                      onPressed: _changingAddress || _currentDistricts.isEmpty
                          ? null
                          : _chooseCurrentDistrict,
                    ),
                    _ValueRow(
                      label: 'Commune',
                      value: _locationName(_currentCommunes, _currentCommuneId),
                      placeholder: 'Required',
                      hasError:
                          _validationAttempted && _currentCommuneId == null,
                      onPressed: _changingAddress || _currentCommunes.isEmpty
                          ? null
                          : _chooseCurrentCommune,
                    ),
                    _ValueRow(
                      label: 'Village',
                      value: _locationName(_currentVillages, _currentVillageId),
                      placeholder: 'Required',
                      hasError:
                          _validationAttempted && _currentVillageId == null,
                      onPressed: _changingAddress || _currentVillages.isEmpty
                          ? null
                          : () async {
                              final value = await _pickLocation(
                                title: 'Current village',
                                options: _currentVillages,
                                selectedId: _currentVillageId,
                              );
                              if (value != null && mounted) {
                                setState(() => _currentVillageId = value.id);
                              }
                            },
                    ),
                    _TextRow(
                      label: 'House',
                      controller: _fields['currentHouse']!,
                      placeholder: 'Optional',
                    ),
                    _TextRow(
                      label: 'Street',
                      controller: _fields['currentStreet']!,
                      placeholder: 'Optional',
                    ),
                  ],
                ),
                CupertinoFormSection.insetGrouped(
                  header: const Text('PERMANENT ADDRESS'),
                  children: [
                    _ValueRow(
                      label: 'Province',
                      value: _locationName(_provinces, _permanentProvinceId),
                      placeholder: 'Required',
                      hasError:
                          _validationAttempted && _permanentProvinceId == null,
                      onPressed: _changingAddress
                          ? null
                          : _choosePermanentProvince,
                    ),
                    _ValueRow(
                      label: 'District',
                      value: _locationName(
                        _permanentDistricts,
                        _permanentDistrictId,
                      ),
                      placeholder: 'Required',
                      hasError:
                          _validationAttempted && _permanentDistrictId == null,
                      onPressed: _changingAddress || _permanentDistricts.isEmpty
                          ? null
                          : _choosePermanentDistrict,
                    ),
                    _ValueRow(
                      label: 'Commune',
                      value: _locationName(
                        _permanentCommunes,
                        _permanentCommuneId,
                      ),
                      placeholder: 'Required',
                      hasError:
                          _validationAttempted && _permanentCommuneId == null,
                      onPressed: _changingAddress || _permanentCommunes.isEmpty
                          ? null
                          : _choosePermanentCommune,
                    ),
                    _ValueRow(
                      label: 'Village',
                      value: _locationName(
                        _permanentVillages,
                        _permanentVillageId,
                      ),
                      placeholder: 'Required',
                      hasError:
                          _validationAttempted && _permanentVillageId == null,
                      onPressed: _changingAddress || _permanentVillages.isEmpty
                          ? null
                          : () async {
                              final value = await _pickLocation(
                                title: 'Permanent village',
                                options: _permanentVillages,
                                selectedId: _permanentVillageId,
                              );
                              if (value != null && mounted) {
                                setState(() => _permanentVillageId = value.id);
                              }
                            },
                    ),
                    _TextRow(
                      label: 'House',
                      controller: _fields['permanentHouse']!,
                      placeholder: 'Optional',
                    ),
                    _TextRow(
                      label: 'Street',
                      controller: _fields['permanentStreet']!,
                      placeholder: 'Optional',
                    ),
                  ],
                ),
              ],
              CupertinoFormSection.insetGrouped(
                header: const Text('FAMILY AND EMERGENCY'),
                children: [
                  _TextRow(
                    label: 'Father name',
                    controller: _fields['fatherName']!,
                    placeholder: 'Optional',
                  ),
                  _TextRow(
                    label: 'Father job',
                    controller: _fields['fatherOccupation']!,
                    placeholder: 'Optional',
                  ),
                  _TextRow(
                    label: 'Father phone',
                    controller: _fields['fatherPhone']!,
                    placeholder: 'Optional',
                    keyboardType: TextInputType.phone,
                  ),
                  _TextRow(
                    label: 'Mother name',
                    controller: _fields['motherName']!,
                    placeholder: 'Optional',
                  ),
                  _TextRow(
                    label: 'Mother job',
                    controller: _fields['motherOccupation']!,
                    placeholder: 'Optional',
                  ),
                  _TextRow(
                    label: 'Mother phone',
                    controller: _fields['motherPhone']!,
                    placeholder: 'Optional',
                    keyboardType: TextInputType.phone,
                  ),
                  _TextRow(
                    label: 'Emergency name',
                    controller: _fields['emergencyName']!,
                    placeholder: 'Required',
                    validator: _required,
                  ),
                  _TextRow(
                    label: 'Emergency phone',
                    controller: _fields['emergencyPhone']!,
                    placeholder: 'Required',
                    keyboardType: TextInputType.phone,
                    validator: _required,
                  ),
                ],
              ),
              CupertinoFormSection.insetGrouped(
                header: const Text('EDUCATION'),
                children: [
                  _TextRow(
                    label: 'High school',
                    controller: _fields['highSchool']!,
                    placeholder: 'Optional',
                  ),
                  _TextRow(
                    label: 'Graduation year',
                    controller: _fields['graduationYear']!,
                    placeholder: 'Optional',
                    keyboardType: TextInputType.number,
                    validator: _yearValidator,
                  ),
                  _ValueRow(
                    label: 'School province',
                    value: _locationName(_provinces, _educationProvinceId),
                    placeholder: 'Optional',
                    onPressed: _loadingLocations
                        ? null
                        : () async {
                            final value = await _pickLocation(
                              title: 'School province',
                              options: _provinces,
                              selectedId: _educationProvinceId,
                            );
                            if (value != null && mounted) {
                              setState(() => _educationProvinceId = value.id);
                            }
                          },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: PrimaryButton(
                  label: 'Save student information',
                  isLoading: _saving,
                  onPressed: _loadingLocations || _changingAddress
                      ? null
                      : _save,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextRow extends StatelessWidget {
  const _TextRow({
    required this.label,
    required this.controller,
    required this.placeholder,
    this.keyboardType,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final String placeholder;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return CupertinoTextFormFieldRow(
      controller: controller,
      prefix: SizedBox(width: 128, child: Text(label)),
      placeholder: placeholder,
      keyboardType: keyboardType,
      validator: validator,
      textAlign: TextAlign.end,
      autocorrect: false,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
    );
  }
}

class _ReadOnlyRow extends StatelessWidget {
  const _ReadOnlyRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return CupertinoFormRow(
      prefix: SizedBox(width: 128, child: Text(label)),
      child: Text(
        value,
        textAlign: TextAlign.end,
        style: const TextStyle(color: AppColors.secondary),
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  const _ValueRow({
    required this.label,
    required this.value,
    required this.placeholder,
    required this.onPressed,
    this.hasError = false,
  });

  final String label;
  final String? value;
  final String placeholder;
  final VoidCallback? onPressed;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return CupertinoFormRow(
      prefix: SizedBox(width: 128, child: Text(label)),
      error: hasError ? const Text('Required') : null,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: const Size(44, 32),
        alignment: Alignment.centerRight,
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                value ?? placeholder,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: value == null
                      ? CupertinoColors.placeholderText.resolveFrom(context)
                      : AppColors.blue,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 5),
            const Icon(CupertinoIcons.chevron_down, size: 14),
          ],
        ),
      ),
    );
  }
}
