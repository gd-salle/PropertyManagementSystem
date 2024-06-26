import 'package:flutter/material.dart';
import '../models/material_sheet.dart';
import '../services/material_sheet_api_service.dart';
import '../widgets/bottom_design.dart';
import '../widgets/top_design.dart';
import '../routes/app_routes.dart';
import 'package:flutter/services.dart';

class ViewMonitoringScreen extends StatefulWidget {
  final MaterialSheet materialSheet;

  ViewMonitoringScreen({required this.materialSheet});

  @override
  _ViewMonitoringScreenState createState() => _ViewMonitoringScreenState();
}

class _ViewMonitoringScreenState extends State<ViewMonitoringScreen> {
  final _formKey = GlobalKey<FormState>();
  late final MaterialSheet _materialSheet;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _materialSheet = widget.materialSheet;
  }

  Future<void> _deleteMaterialSheet() async {
    try {
      bool success = await MaterialSheetApiService.deleteMaterialSheet(_materialSheet.id!);
      if (success) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Deletion Successful'),
              content: Text('Successfully deleted. You are now being redirected to the previous screen...'),
            );
          },
        );

        await Future.delayed(Duration(seconds: 1));

        Navigator.pop(context);
        Navigator.pushNamed(context, AppRoutes.materialMonitoringPage);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete material sheet')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this material sheet?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteMaterialSheet();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      try {
        bool success = await MaterialSheetApiService.updateMaterialSheet(_materialSheet);
        if (success) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Update Successful'),
                content: Text('Redirecting you to the previous page...'),
              );
            },
          );

          await Future.delayed(Duration(seconds: 1));

          Navigator.pop(context);
          Navigator.pushNamed(context, AppRoutes.materialMonitoringPage);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update material sheet')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Update'),
          content: Text('Are you sure you want to update this material sheet?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _saveChanges();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopDesign(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/unc_logo.png',
                    height: 50,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'UNIVERSITY OF NUEVA CACERES',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Material Monitoring Sheet',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Property Management Office',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              color: Colors.grey[300],
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'View',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      _buildTextField('Department', _materialSheet.department, (value) => _materialSheet.department = value),
                      _buildTextField('Laboratory', _materialSheet.laboratory, (value) => _materialSheet.laboratory = value),
                      _buildTextField('Date', _materialSheet.date, (value) => _materialSheet.date = value),
                      _buildTextField('Accountable Person', _materialSheet.accountablePerson, (value) => _materialSheet.accountablePerson = value),
                      Row(
                        children: [
                          Expanded(child: _buildIntField('Quantity', _materialSheet.qty.toString(), (value) => _materialSheet.qty = int.parse(value))),
                          SizedBox(width: 8),
                          Expanded(child: _buildTextField('UNIT', _materialSheet.unit, (value) => _materialSheet.unit = value)),
                        ],
                      ),
                      _buildTextField('Description', _materialSheet.description, (value) => _materialSheet.description = value),
                      _buildIntField('P.O Number', _materialSheet.poNumber, (value) => _materialSheet.poNumber = value),
                      _buildIntField('Account Code', _materialSheet.accountCode, (value) => _materialSheet.accountCode = value),
                      _buildTextField('Account Name', _materialSheet.accountName, (value) => _materialSheet.accountName = value),
                      _buildIntField('Tag Number', _materialSheet.tagNumber, (value) => _materialSheet.tagNumber = value),
                      _buildTextField('Acquisition Date', _materialSheet.acquisitionDate, (value) => _materialSheet.acquisitionDate = value),
                      _buildTextField('Location', _materialSheet.location, (value) => _materialSheet.location = value),
                      _buildDoubleField('Unit Price', _materialSheet.unitPrice, (value) => _materialSheet.unitPrice = value),
                      _buildDoubleField('Total', _materialSheet.total, (value) => _materialSheet.total = value),
                      _buildTextField('Remarks', _materialSheet.remarks, (value) => _materialSheet.remarks = value),
                      _buildIntField('MR#', _materialSheet.mrNumber, (value) => _materialSheet.mrNumber = value),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_isEditing) {
                          _showConfirmationDialog();
                        } else {
                          setState(() {
                            _isEditing = !_isEditing;
                          });
                        }
                      },
                      child: Text(_isEditing ? 'Confirm' : 'Modify', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isEditing ? Colors.green : Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_isEditing) {
                          setState(() {
                            _isEditing = false;
                          });
                        } else {
                          _showDeleteConfirmationDialog();
                        }
                      },
                      child: Text(_isEditing ? 'Cancel' : 'Delete', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isEditing ? Colors.red : Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BottomDesign(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, String initialValue, Function(String) onSave) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: initialValue,
              decoration: InputDecoration(
                labelText: hint,
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onSaved: (value) => onSave(value!),
              validator: (value) => value!.isEmpty ? 'Please enter ${hint.toLowerCase()}' : null,
              enabled: _isEditing,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntField(String hint, String initialValue, Function(String) onSave) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: initialValue,
              decoration: InputDecoration(
                labelText: hint,
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onSaved: (value) => onSave(value!),
              validator: (value) => value!.isEmpty ? 'Please enter ${hint.toLowerCase()}' : null,
              enabled: _isEditing,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoubleField(String hint, double initialValue, Function(double) onSave) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: initialValue.toString(),
              decoration: InputDecoration(
                labelText: hint,
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  onSave(double.parse(value));
                } else {
                  onSave(initialValue);
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter ${hint.toLowerCase()}';
                } else if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              enabled: _isEditing,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
            ),
          ),
        ],
      ),
    );
  }
}
