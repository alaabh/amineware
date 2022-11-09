import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  late bool isError;
  late bool isLoading;
  @override
  void initState() {
    super.initState();
    isError = false;
    isLoading = true;
  }

  getItems(String text) {
    List<String> list = [];
    for (int i = 0; i < text.length - 1; i++) {
      var item = text.substring(i, i + 10);
      print(item);
      if (verif(item)) {
        list.add(item);
        i = i + 9;
      } else {
        setState(() {
          isError = true;
        });
      }
    }
    return list;
  }

  TextEditingController listController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("please respect this form: \n A11111111BZ22222222X... "),
              SizedBox(
                height: 20,
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextFormField(
                    style: const TextStyle(backgroundColor: Color(0xFFFFFFFF)),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Employees List',
                    ),
                    controller: listController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[A-Z 0-9]')),
                      FilteringTextInputFormatter.deny(RegExp(' ')),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(211, 38, 38, 1)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)))),
                child: const Text(
                  'Get List',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    isLoading = false;
                  });
                },
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: isLoading
                    ? Text("")
                    : Text(isError
                        ? "erreur de saisie "
                        : sortByNumber(getItems(listController.text))
                            .toString()),
              )
            ],
          ),
        ),
      ),
    );
  }
}

sortByFirstChar(List<String> list) {
  for (int i = 0; i < list.length; i++) {
    for (int j = 0; j < list.length; j++) {
      if (list[i][0].compareTo(list[j][0]) == -1) {
        var aux = list[i];
        list[i] = list[j];
        list[j] = aux;
      }
    }
  }
  return list;
}

sortByLastChar(List<String> list) {
  for (int i = 0; i < list.length; i++) {
    for (int j = 0; j < list.length; j++) {
      if ((list[i][0].compareTo(list[j][0]) == 0) &&
          (list[i][9].compareTo(list[j][9]) == -1)) {
        var aux = list[i];
        list[i] = list[j];
        list[j] = aux;
      }
    }
  }
  return list;
}

sortByNumber(List<String> list) {
  sortByFirstChar(list);
  sortByLastChar(list);
  for (int i = 0; i < list.length; i++) {
    for (int j = 0; j < list.length; j++) {
      if ((list[i][0].compareTo(list[j][0]) == 0) &&
          (list[i][9].compareTo(list[j][9]) == 0) &&
          (list[i].substring(1, 8).compareTo(list[j].substring(1, 8))) == -1) {
        var aux = list[i];
        list[i] = list[j];
        list[j] = aux;
      }
    }
  }
  return list;
}

verif(text) {
  return (text[0].contains(RegExp('^[A-Z]+')) &&
      text[9].contains(RegExp('^[A-Z]+')) &&
      isNumeric(text.substring(1, 8)));
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}
