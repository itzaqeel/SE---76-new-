import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/Pages/FYI.dart';
import 'package:vector_math/vector_math_64.dart' as vector64;
import '../Pages/service/database.dart';

class ArMysteryBoxScreen extends StatefulWidget {
  const ArMysteryBoxScreen({super.key});


  @override
  State<ArMysteryBoxScreen> createState() => _ArMysteryBoxScreenState();
}

class _ArMysteryBoxScreenState extends State<ArMysteryBoxScreen> {
  ArCoreController? coreController;
  final Session session = Session();
  double userXp = 0;

  augmentedRealityViewCreated(ArCoreController controller){
    coreController = controller;

    displayCube(coreController!);
  }

  displayCube(ArCoreController controller)async{
    final ByteData questionMtextureBytes = await rootBundle.load("assets/QM.png");

    final materials = ArCoreMaterial(
      color: Colors.purple,
      textureBytes: questionMtextureBytes.buffer.asUint8List(),
    );

    final cube = ArCoreCube(
      size: vector64.Vector3(0.75,0.75,0.75),
      materials: [materials],
    );

    final node = ArCoreNode(
      shape: cube,
      position: vector64.Vector3(-0.5,0.5,-3.5),
    );

    coreController!.addArCoreNode(node);
  }


  void fetchAndSetCharacter() async {
    UserModel currentUser = await session.getCurrentUser();
    if (currentUser != null) {
      setState(() {
        userXp = currentUser.xp;
      });
    }
  }
  void updateSession() async {
    // Increment character value in the session by 1
    UserModel currentUser = await session.getCurrentUser();
    if (currentUser != null) {
      currentUser.character = ++currentUser.character;
      currentUser.xp = (currentUser.xp + 12)/100;
      currentUser.hp = ++currentUser.hp;
      currentUser.accessory = ++currentUser.accessory;
      await session.updateUserData(currentUser);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAndSetCharacter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black, // Change the background color of the container
        child: Column(
          children: [
            Expanded(
              child: ArCoreView(
                onArCoreViewCreated: augmentedRealityViewCreated,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  updateSession();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FYI()),
                  );
                },
                child: const Text('Claim'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color.fromRGBO(0, 162, 142, 1)), // Change button background color to black
                  foregroundColor: MaterialStateProperty.all(Colors.white), // Change text color here
                  minimumSize: MaterialStateProperty.all(const Size(120, 40)),
                  textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



