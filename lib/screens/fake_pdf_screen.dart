import 'package:flutter/material.dart';

class FakePdfScreen extends StatelessWidget {
  const FakePdfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // To make it look like a real PDF reader app, we use a light grey background
    // for the "reader" behind the "page" itself.
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        backgroundColor: Colors.white,
      body: SafeArea(
        child: InteractiveViewer(
          panEnabled: true,
          scaleEnabled: true,
          minScale: 1.0,
          maxScale: 4.0,
          constrained: false,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "ZARATHUSTRA'S PROLOGUE",
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                const Text(
                  '''1.\nWhen Zarathustra was thirty years old, he left his home and the lake of his home, and went into the mountains. There he enjoyed his spirit and his solitude, and for ten years did not weary of it. But at last his heart changed,—and rising one morning with the rosy dawn, he went before the sun, and spake thus unto it:\n\nThou great star! What would be thy happiness if thou hadst not those for whom thou shinest! For ten years hast thou climbed hither unto my cave: thou wouldst have wearied of thy light and of the journey, had it not been for me, my eagle, and my serpent.\n\nBut we awaited thee every morning, took from thee thine overflow, and blessed thee for it. Lo! I am weary of my wisdom, like the bee that hath gathered too much honey; I need hands outstretched to take it. I would fain bestow and distribute, until the wise have once more become joyous in their folly, and the poor happy in their riches.\n\nTherefore must I descend into the deep: as thou doest in the evening, when thou goest behind the sea, and givest light also to the nether-world, thou exuberant star! Like thee must I go down, as men say, to whom I shall descend.''',
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 60),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "9",
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                const Text(
                  '''2.\nZarathustra went down the mountain alone, no one meeting him. When he entered the forest, however, there suddenly stood before him an old man, who had left his holy cot to seek roots. And thus spake the old man to Zarathustra:\n\n"No stranger to me is this wanderer: many years ago passed he by. Zarathustra he was called; but he hath altered. Then thou carriedst thine ashes into the mountains: wilt thou now carry thy fire into the valleys? Fearest thou not the incendiary's doom?\n\nYea, I recognise Zarathustra. Pure is his eye, and no loathing lurketh about his mouth. Goeth he not along like a dancer? Altered is Zarathustra; a child hath Zarathustra become; an awakened one is Zarathustra: what wilt thou do in the land of the sleepers?"\n\nZarathustra answered: "I love mankind." "Why," said the saint, "did I go into the forest and the desert? Was it not because I loved men far too well? Now I love God: men, I do not love. Man is a thing too imperfect for me. Love to man would be fatal to me."\n\nZarathustra answered: "What spake I of love! I am bringing gifts unto men."\n\n"Give them nothing," said the saint. "Take rather part of their load, and carry it along with them—that will be most agreeable unto them: if only it be agreeable unto thee!"''',
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 160),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "10",
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
