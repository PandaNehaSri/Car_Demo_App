import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/car.dart';
import '../providers/booking_provider.dart';
import 'confirmation_screen.dart';

class BookingFormScreen extends StatefulWidget {
  final Car car;
  const BookingFormScreen({Key? key, required this.car}) : super(key: key);
  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _locCtrl = TextEditingController();
  DateTime? _from;
  DateTime? _to;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _locCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFrom() async {
    final p = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder:
          (_, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(primary: Color(0xFF6C63FF)),
            ),
            child: child!,
          ),
    );
    if (p != null) setState(() => _from = p);
  }

  Future<void> _pickTo() async {
    final init = _from ?? DateTime.now();
    final p = await showDatePicker(
      context: context,
      initialDate: init,
      firstDate: init,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder:
          (_, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(primary: Color(0xFF6C63FF)),
            ),
            child: child!,
          ),
    );
    if (p != null) setState(() => _to = p);
  }

  void _confirm() {
    if (!_formKey.currentState!.validate()) return;
    if (_from == null || _to == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Select both dates'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }
    if (_to!.isBefore(_from!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('End date must be after start date'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }
    final prov = Provider.of<BookingProvider>(context, listen: false);
    prov.createBooking(
      userName: _nameCtrl.text.trim(),
      car: widget.car,
      fromDate: _from!,
      toDate: _to!,
      location: _locCtrl.text.trim(),
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const ConfirmationScreen()),
    );
  }

  String _fmt(DateTime? d) =>
      d == null ? 'Select Date' : '${d.day}/${d.month}/${d.year}';
  int _days() =>
      _from == null || _to == null ? 0 : _to!.difference(_from!).inDays + 1;
  double _total() => _days() * widget.car.pricePerDay;

  @override
  Widget build(BuildContext context) {
    final days = _days();
    final total = _total();
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: const Text('Complete Booking'),
        backgroundColor: const Color(0xFF6C63FF),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              color: const Color(0xFF6C63FF).withOpacity(0.1),
                              padding: const EdgeInsets.all(8),
                              child: Image.network(
                                widget.car.imageUrl,
                                width: 80,
                                height: 60,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.car.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3142),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '₹${widget.car.pricePerDay.toStringAsFixed(0)} / day',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator:
                          (v) =>
                              v?.trim().isEmpty ?? true ? 'Enter name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _locCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Pickup Location',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      validator:
                          (v) =>
                              v?.trim().isEmpty ?? true
                                  ? 'Enter location'
                                  : null,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Rental Period',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: _pickFrom,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      _from != null
                                          ? const Color(0xFF6C63FF)
                                          : Colors.grey[300]!,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_outlined,
                                        size: 16,
                                        color:
                                            _from != null
                                                ? const Color(0xFF6C63FF)
                                                : Colors.grey[600],
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Start Date',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _fmt(_from),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          _from != null
                                              ? const Color(0xFF2D3142)
                                              : Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: _pickTo,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      _to != null
                                          ? const Color(0xFF6C63FF)
                                          : Colors.grey[300]!,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_outlined,
                                        size: 16,
                                        color:
                                            _to != null
                                                ? const Color(0xFF6C63FF)
                                                : Colors.grey[600],
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'End Date',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _fmt(_to),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          _to != null
                                              ? const Color(0xFF2D3142)
                                              : Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (days > 0) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF6C63FF).withOpacity(0.1),
                              const Color(0xFF8B84FF).withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$days ${days == 1 ? "day" : "days"}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2D3142),
                              ),
                            ),
                            Text(
                              '₹${total.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6C63FF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _confirm,
                  child: const Text(
                    'Confirm Booking',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
