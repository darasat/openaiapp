import 'package:flutter/material.dart';
import 'package:openaiapp/colors.dart';
import 'api_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var sizes = ["Small", "Medium", "Large"];
  var values = ["256x256", "512x512", "1024x1024"];
  String? dropValue;
  var textController = TextEditingController();
  String image = '';
  var isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Generador de Imágenes AI",
          style: TextStyle(fontFamily: "poppins_bold", color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(12)),
                              child: TextFormField(
                                controller: textController,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Ej: crear imagen de fútbol"),
                              ))),
                      const SizedBox(width: 12),
                      Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                icon: const Icon(Icons.expand_more,
                                    color: btnColor),
                                value: dropValue,
                                hint: const Text("Selecciona el tamaño"),
                                items: List.generate(
                                    sizes.length,
                                    (index) => DropdownMenuItem(
                                        value: values[index],
                                        child: Text(sizes[index]))),
                                onChanged: (value) {
                                  setState(() {
                                    dropValue = value.toString();
                                  });
                                })),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 300,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: dropValue == null
                          ? null
                          : () async {
                              if (dropValue!.isNotEmpty &&
                                  textController.text.isNotEmpty) {
                                setState(() {
                                  isLoaded = false;
                                });
                                image = await Api.generateImage(
                                    textController.text, dropValue!);
                                setState(() {
                                  isLoaded = true;
                                });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text("Generar imagen"),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                flex: 3,
                child: isLoaded
                    ? Image.network(image)
                    : Container(
                        clipBehavior: Clip.antiAlias,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: whiteColor),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/loader.gif"),
                            const SizedBox(
                              height: 12.0,
                            ),
                            const Text(
                              "Esperando por la imagen",
                              style: TextStyle(fontSize: 16.0),
                            )
                          ],
                        ),
                      )),
          ],
        ),
      ),
    );
  }
}
