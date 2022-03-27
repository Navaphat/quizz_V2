import 'dart:convert';

import 'package:final_620710663/models/Item.dart';
import 'package:final_620710663/models/api_result.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'data.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _LoadItem();
  }
  int _index = 0;
  int _totalIncorrect = 0;
  @override
  Widget build(BuildContext context) {
    var itemData = Data.list[_index];
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Image.network(Data.list[_index].image_url),
              for(int i = 0; i < itemData.choices.length; i++) _viewChoices(itemData, i),
            ],
          ),
        ],
      ),
    );
  }

  _LoadItem() async {
      Uri url = Uri.parse("https://cpsu-test-api.herokuapp.com/quizzes");
      var response = await http.get(url, headers: {'id': '620710663'});

      var json = jsonDecode(response.body);
      var apiResult = ApiResult.fromJson(json);

      setState(() {
        Data.list = apiResult.data.map<Item>((item) => Item.fromJson(item)).toList();
        print('Successful');
      });
  }

  Widget _viewChoices(Item itemData, int index) {
    return Card(
      child: Expanded(
        child: ElevatedButton(
          onPressed: () {
            if(itemData.choices[index] == itemData.answer) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Message'),
                      content: Text('Correct'),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _index++;
                                Navigator.of(context).pop();
                              });
                            },
                            child: Text('Ok')
                        )
                      ],
                    );
                  }
              );
            }
            else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Message'),
                      content: Text('Incorrect'),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _totalIncorrect++;
                                Navigator.of(context).pop();
                              });
                            },
                            child: Text('Ok')
                        )
                      ],
                    );
                  }
              );
            }
          },
          child: Text(itemData.choices[index]),
        ),
      ),
    );
  }
}
