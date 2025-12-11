import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/address_service.dart';

// Riverpod providers for address service
final addressServiceProvider = Provider<AddressService>((ref) => AddressService());

final wardsDataProvider = FutureProvider<List<Ward>>((ref) async {
  final addressService = ref.watch(addressServiceProvider);
  return await addressService.loadAllWards();
});

class QuickBookingScreen extends ConsumerStatefulWidget {
  final String? serviceName;

  const QuickBookingScreen({
    super.key,
    this.serviceName,
  });

  @override
  ConsumerState<QuickBookingScreen> createState() => _QuickBookingScreenState();
}

class _QuickBookingScreenState extends ConsumerState<QuickBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _jobContentController = TextEditingController();
  final _wardSearchController = TextEditingController();
  final _streetAddressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();

  Timer? _searchDebounce;
  Ward? _selectedWard;
  List<Ward> _searchResults = [];
  bool _isSearching = false;

  bool _needsSurvey = false;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    // Pre-fill job content if service name is provided
    if (widget.serviceName != null) {
      _jobContentController.text = widget.serviceName!;
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _jobContentController.dispose();
    _wardSearchController.dispose();
    _streetAddressController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _searchWards(String query, List<Ward> allWards) {
    _searchDebounce?.cancel();
    
    if (query.isEmpty || query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      try {
        final lowerQuery = query.toLowerCase().trim();
        
        final results = allWards.where((ward) {
          final nameMatch = ward.name.toLowerCase().contains(lowerQuery);
          final nameWithTypeMatch = ward.nameWithType.toLowerCase().contains(lowerQuery);
          final pathMatch = ward.path.toLowerCase().contains(lowerQuery);
          final pathWithTypeMatch = ward.pathWithType.toLowerCase().contains(lowerQuery);
          
          return nameMatch || nameWithTypeMatch || pathMatch || pathWithTypeMatch;
        }).toList();

        // Sort by relevance: exact matches first, then starts with, then contains
        results.sort((a, b) {
          final aName = a.name.toLowerCase();
          final bName = b.name.toLowerCase();
          final aNameWithType = a.nameWithType.toLowerCase();
          final bNameWithType = b.nameWithType.toLowerCase();
          
          // Exact match
          if (aName == lowerQuery && bName != lowerQuery) return -1;
          if (aName != lowerQuery && bName == lowerQuery) return 1;
          
          // Starts with
          if (aName.startsWith(lowerQuery) && !bName.startsWith(lowerQuery)) return -1;
          if (!aName.startsWith(lowerQuery) && bName.startsWith(lowerQuery)) return 1;
          if (aNameWithType.startsWith(lowerQuery) && !bNameWithType.startsWith(lowerQuery)) return -1;
          if (!aNameWithType.startsWith(lowerQuery) && bNameWithType.startsWith(lowerQuery)) return 1;
          
          return 0;
        });

        if (mounted) {
          setState(() {
            _searchResults = results.take(10).toList(); // Limit to 10 results
            _isSearching = false;
          });
        }
      } catch (e) {
        print('Error in search: $e');
        if (mounted) {
          setState(() {
            _searchResults = [];
            _isSearching = false;
          });
        }
      }
    });
  }

  void _selectWard(Ward ward) {
    setState(() {
      _selectedWard = ward;
      _wardSearchController.text = ward.pathWithType;
      _searchResults = [];
    });
    FocusScope.of(context).unfocus();
  }

  bool get _isFormValid {
    return _jobContentController.text.isNotEmpty &&
        _selectedWard != null &&
        _streetAddressController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _nameController.text.isNotEmpty &&
        _selectedDate != null &&
        _selectedTime != null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = now;
    final DateTime lastDate = now.add(const Duration(days: 30));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: firstDate,
      lastDate: lastDate,
      locale: const Locale('vi', 'VN'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFFFFC107),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFFFFC107),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String _getDayOfWeekAbbreviation(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'T2';
      case 2:
        return 'T3';
      case 3:
        return 'T4';
      case 4:
        return 'T5';
      case 5:
        return 'T6';
      case 6:
        return 'T7';
      case 7:
        return 'CN';
      default:
        return '';
    }
  }

  List<DateTime> _getUpcomingDays() {
    final List<DateTime> days = [];
    final DateTime now = DateTime.now();
    for (int i = 0; i < 5; i++) {
      days.add(now.add(Duration(days: i)));
    }
    return days;
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate() && _isFormValid) {
      // Navigate to success screen
      context.pushReplacement('/booking-success');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin bắt buộc'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final wardsAsync = ref.watch(wardsDataProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Yellow Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFFFC107),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.black87),
                    ),
                    onPressed: () => context.pop(),
                  ),
                  const Expanded(
                    child: Text(
                      'Đặt lịch nhanh chóng',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the back button
                ],
              ),
            ),
            // Form Content
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Job Content Field
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          children: [
                            TextSpan(text: 'Nội dung công việc '),
                            TextSpan(
                              text: '*',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _jobContentController,
                        decoration: InputDecoration(
                          hintText: 'Nhập nội dung công việc',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFFFC107)),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập nội dung công việc';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      // Survey Checkbox
                      Row(
                        children: [
                          Checkbox(
                            value: _needsSurvey,
                            onChanged: (value) {
                              setState(() {
                                _needsSurvey = value ?? false;
                              });
                            },
                            activeColor: const Color(0xFFFFC107),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const Expanded(
                            child: Text(
                              'Khảo sát tư vấn tận nơi, báo giá trước miễn phí',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Ward/Province/City Field
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          children: [
                            TextSpan(text: 'Xã - Thành phố / Tỉnh '),
                            TextSpan(
                              text: '*',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      wardsAsync.when(
                        data: (allWards) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _wardSearchController,
                              decoration: InputDecoration(
                                hintText: 'Tìm kiếm Xã - Thành phố / Tỉnh',
                                prefixIcon: _isSearching
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: Padding(
                                          padding: EdgeInsets.all(12),
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFC107)),
                                          ),
                                        ),
                                      )
                                    : const Icon(Icons.search, color: Color(0xFFFFC107)),
                                suffixIcon: _selectedWard != null
                                    ? IconButton(
                                        icon: const Icon(Icons.clear, size: 20),
                                        onPressed: () {
                                          setState(() {
                                            _selectedWard = null;
                                            _wardSearchController.clear();
                                            _searchResults = [];
                                          });
                                        },
                                      )
                                    : null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Color(0xFFFFC107)),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              onChanged: (value) {
                                if (_selectedWard != null && value != _selectedWard!.pathWithType) {
                                  setState(() {
                                    _selectedWard = null;
                                  });
                                }
                                _searchWards(value, allWards);
                              },
                              validator: (value) {
                                if (_selectedWard == null) {
                                  return 'Vui lòng chọn  Xã - Thành phố / Tỉnh';
                                }
                                return null;
                              },
                            ),
                            // Search Results Dropdown
                            if (_wardSearchController.text.trim().isNotEmpty && 
                                !_isSearching && 
                                _selectedWard == null)
                              _searchResults.isEmpty
                                  ? Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey[300]!),
                                      ),
                                      child: const Text(
                                        'Không tìm thấy kết quả',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      constraints: const BoxConstraints(maxHeight: 250),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey[300]!),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          itemCount: _searchResults.length > 10 ? 10 : _searchResults.length,
                                          separatorBuilder: (context, index) => Divider(
                                            height: 1,
                                            thickness: 1,
                                            color: Colors.grey[200],
                                          ),
                                          itemBuilder: (context, index) {
                                            final ward = _searchResults[index];
                                            return InkWell(
                                              onTap: () => _selectWard(ward),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      ward.nameWithType,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      ward.pathWithType,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                          ],
                        ),
                        loading: () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _wardSearchController,
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: 'Đang tải dữ liệu...',
                                prefixIcon: const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFC107)),
                                    ),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                            ),
                          ],
                        ),
                        error: (error, stack) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _wardSearchController,
                              decoration: InputDecoration(
                                hintText: 'Lỗi tải dữ liệu. Vui lòng thử lại',
                                prefixIcon: const Icon(Icons.error_outline, color: Colors.red),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Lỗi: ${error.toString()}',
                              style: const TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Street Address Field
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          children: [
                            TextSpan(text: 'Số nhà / đường '),
                            TextSpan(
                              text: '*',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _streetAddressController,
                        decoration: InputDecoration(
                          hintText: 'Vui lòng nhập số nhà, tên đường',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFFFC107)),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập số nhà / đường';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Phone Number Field
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          children: [
                            TextSpan(text: 'Số điện thoại '),
                            TextSpan(
                              text: '*',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('🇻🇳', style: TextStyle(fontSize: 16)),
                                const SizedBox(width: 4),
                                const Text(
                                  '+84',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(
                                hintText: 'Số điện thoại của Quý Khách',
                                border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                  borderSide: const BorderSide(color: Color(0xFFFFC107)),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập số điện thoại';
                                }
                                if (value.length < 9 || value.length > 10) {
                                  return 'Số điện thoại không hợp lệ';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Name Field
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          children: [
                            TextSpan(text: 'Họ và tên '),
                            TextSpan(
                              text: '*',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Vui lòng nhập họ và tên',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFFFC107)),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập họ và tên';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Notes Field
                      const Text(
                        'Ghi chú cho thợ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Vui lòng nhập ghi chú nếu có',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFFFC107)),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Suggestions
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gợi ý:',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '- Nhập thêm địa chỉ, số căn hộ, tháp chung cư,..',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '- Nhập thêm tình trạng thiết bị cần sửa, mang thang cao,..',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Date & Time Selection
                      const Text(
                        'Chọn ngày & giờ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Date Buttons
                      SizedBox(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ..._getUpcomingDays().map((date) {
                              final isSelected = _selectedDate != null &&
                                  _selectedDate!.year == date.year &&
                                  _selectedDate!.month == date.month &&
                                  _selectedDate!.day == date.day;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedDate = date;
                                  });
                                },
                                child: Container(
                                  width: 80,
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFFFFC107)
                                        : Colors.white,
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFFFFC107)
                                          : Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _getDayOfWeekAbbreviation(date),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${date.day}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Tháng ${date.month}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isSelected
                                              ? Colors.white70
                                              : Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                            // "See more" button
                            GestureDetector(
                              onTap: () => _selectDate(context),
                              child: Container(
                                width: 80,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color(0xFFFFC107),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color: Color(0xFFFFC107),
                                      size: 24,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Xem thêm',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFFFFC107),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Today's Date Display
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDate = DateTime.now();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                              const SizedBox(width: 12),
                              Text(
                                _selectedDate != null
                                    ? '${_getDayOfWeekAbbreviation(_selectedDate!)}, ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}'
                                    : 'Hôm nay (${_getDayOfWeekAbbreviation(DateTime.now())}, ${DateFormat('dd/MM/yyyy').format(DateTime.now())})',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Time Selection
                      GestureDetector(
                        onTap: () => _selectTime(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time, size: 20, color: Colors.grey),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _selectedTime != null
                                      ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                                      : 'Chọn giờ:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _selectedTime != null
                                        ? Colors.black87
                                        : Colors.grey[600],
                                  ),
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
            // Submit Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isFormValid ? _submitBooking : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid
                        ? const Color(0xFFFFC107)
                        : Colors.grey[300],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Đặt lịch ngay',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
