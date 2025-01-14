import 'package:flutter/material.dart';
import 'package:green_market/components/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:green_market/models/models.dart';

class AddRequirementScreen extends StatefulWidget {
  const AddRequirementScreen({super.key});

  @override
  State<AddRequirementScreen> createState() => _AddRequirementScreenState();
}

class _AddRequirementScreenState extends State<AddRequirementScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _farmerName;
  String? _district;
  String? _address;
  String? _phoneNumber;
  String? _cultivatedArea;
  String? _groupType;

  String? _farmerType;
  int? _weight;
  DateTime? _requiredDate;
  int? _price;
  List<File> _images = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _requiredDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Crop",
        ),
        backgroundColor: kColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                style: TextStyle(fontWeight: FontWeight.w500),
                decoration: InputDecoration(labelText: "Buyer's Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter buyer's name";
                  }
                  return null;
                },
                onSaved: (value) {
                  _farmerName = value;
                },
              ),
              SizedBox(height: 15),
              DropdownButtonFormField<String>(
                menuMaxHeight: MediaQuery.of(context).size.height * 0.3,
                decoration: InputDecoration(
                  labelText: 'District',
                  // suffixIcon: Icon(
                  //   Icons.keyboard_arrow_down_outlined,
                  //   size: 30,
                  // ),
                ),
                icon: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.keyboard_arrow_down_outlined,
                    size: 25,
                  ),
                ),
                items: districts.map((String district) {
                  return DropdownMenuItem<String>(
                    value: district,
                    child: Text(district),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _district = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a district';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                style: TextStyle(fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                    labelText: 'Address',
                    hintText: 'Eg: No, Street, City',
                    hintStyle: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.normal),
                    suffixIcon: Icon(
                      Icons.location_on,
                      size: 20,
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _address = value;
                },
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Phone Number',
                          prefixText: '+94 ',
                          prefixStyle: TextStyle(fontWeight: FontWeight.w500),
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal),
                          hintText: 'XX XXX XXX'),
                      style: TextStyle(fontWeight: FontWeight.w500),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _phoneNumber = value;
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      decoration: InputDecoration(labelText: 'Crop Type'),
                      icon: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: 25,
                        ),
                      ),
                      items: weightRange.map((int weight) {
                        return DropdownMenuItem<int>(
                          value: weight,
                          child: Text('$weight kg',
                              style: TextStyle(fontSize: 16)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _weight = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a crop type';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      decoration: InputDecoration(labelText: 'Weight'),
                      icon: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: 25,
                        ),
                      ),
                      items: weightRange.map((int weight) {
                        return DropdownMenuItem<int>(
                          value: weight,
                          child: Text('$weight kg',
                              style: TextStyle(fontSize: 16)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _weight = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a weight';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Required Date',
                              suffixIcon: Icon(Icons.calendar_today)),
                          controller: TextEditingController(
                              text: _requiredDate == null
                                  ? ''
                                  : _requiredDate
                                      ?.toLocal()
                                      .toIso8601String()
                                      .substring(0, 10)),
                          validator: (value) {
                            if (_requiredDate == null) {
                              return 'Please select the required date';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 168, 165, 165)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Submit button action
                        // Handle form submission here
                      }
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
