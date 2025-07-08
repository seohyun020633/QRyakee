import 'package:flutter/material.dart';
import 'package:flutter_application/constant/colors.dart';
import 'package:flutter_application/pharmacy_search_detail.dart';
import '../constant/input_styles.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'signup_pharmacy_screen',
      home: const PharmacySearchPage(),
    );
  }
}



class PharmacySearchPage extends StatefulWidget {
  const PharmacySearchPage({super.key});

  @override
  State<PharmacySearchPage> createState() => _PharmacySearchPageState();
}

class _PharmacySearchPageState extends State<PharmacySearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _allItems = [
    '타이레놀', '아스피린', '부루펜', '지르텍', '알레그라'
  ];
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = _allItems;
  }

  void _filterSearch(String query) {
    setState(() {
      _filteredItems = _allItems
          .where((item) => item.contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
         elevation: 0,
         centerTitle: true,
         automaticallyImplyLeading: false,
        title: const Text('약품 검색', style: TextStyle(fontSize: 21,
         fontWeight: FontWeight.bold, color: AppColors.primary),),      
      ),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.fromLTRB(0, 10, 0, 0)),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              onChanged: _filterSearch,
//은지 코드
              decoration: buildInputDecoration(hint: '검색어를 입력하세요').copyWith(
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
//
              cursorColor: AppColors.sub,
              decoration: InputDecoration(
                hintText: '검색어를 입력하세요',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey,),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
//
              ),
            ),
                      ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                String drugname = _filteredItems[index];
               return ListTile(
                title: Text(_filteredItems[index]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DrugDetailPage(selectedDrugName: drugname),
                    ),
                  );
                },
              );
              },
            ),
          ),
        ],
      ),
    );
  }
}