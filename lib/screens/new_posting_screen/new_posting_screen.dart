import 'package:flutter/material.dart';

class NewPostingScreen extends StatefulWidget {
  final String petId;
  const NewPostingScreen({
    super.key,
    required this.petId
  });

  @override
  State<NewPostingScreen> createState() => _NewPostingScreenState();
}

class _NewPostingScreenState extends State<NewPostingScreen> {

  
  DateTime? selectedDate;
  DateTime today = DateTime.now();
  DateTime? firstDate;
  DateTime? lastDate;
  DateTime? initialDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialDate = DateTime(today.year,today.month,today.day);
    firstDate = DateTime(2000);
    lastDate = DateTime(today.year);

  }
  

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate!,
      lastDate: initialDate!,
    );

    setState(() {
      selectedDate = pickedDate;
    });
  }  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Posting"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
                
                // Date controller
        
        
                const SizedBox(height: 16),
        
        
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              border: Border.all(
                                width: 1.0
                              )
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                selectedDate != null
                                    ? 'Missing since ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                    : 'Missing Since',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              )
                            ),
                            onPressed: _selectDate,
                            child: Text("Date")
                          )                        
                        )
                      ],
                    ),              
                Row(
                  children: [
                    Text(
                      selectedDate != null
                          ? 'Missing since ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                          : 'No date selected',
                    ),
        
        
                  ]
                ),
        
          
          ],
        ),
      ),
    );
  }
}