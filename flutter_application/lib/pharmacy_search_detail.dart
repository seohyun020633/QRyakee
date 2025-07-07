import 'package:flutter/material.dart';
import 'package:flutter_application/constant/colors.dart';

class DrugDetailPage extends StatefulWidget {
  final String selectedDrugName;
  const DrugDetailPage({required this.selectedDrugName});

  @override
  _DrugDetailPageState createState() => _DrugDetailPageState();
}

class _DrugDetailPageState extends State<DrugDetailPage> {
  final TextEditingController _searchController = TextEditingController();
  String _interactionResult = '';

  void _searchInteraction(String otherDrug) {
    setState(() {
      _interactionResult = '${widget.selectedDrugName}과(와) $otherDrug 의 상호작용: 간독성 증가 위험';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
         elevation: 0,
         centerTitle: true,
         title: Text(widget.selectedDrugName,style: TextStyle(
         fontSize: 21,fontWeight: FontWeight.bold, color: Colors.black),),),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.fromLTRB(0, 10, 0, 0)),
            Text('대표 상호작용 5가지', style: TextStyle(fontSize: 19)),
            ...['간 효소 증가', '졸림 유발', '심장 박동 증가', '혈압 상승', '위장 장애'].map((e) => Text('• $e', style: TextStyle(fontSize: 17),)),
            const SizedBox(height: 24),
            TextField(
              controller: _searchController,
              cursorColor: AppColors.sub,
              decoration: InputDecoration(
                labelText: '다른 약물 검색',
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: Colors.grey,),
                  onPressed: () => _searchInteraction(_searchController.text),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_interactionResult.isNotEmpty) Text(_interactionResult),
          ],
        ),
      ),
    );
  }
}