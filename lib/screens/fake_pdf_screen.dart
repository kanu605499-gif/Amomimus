import 'package:flutter/material.dart';

class FakePdfScreen extends StatelessWidget {
  const FakePdfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // To make it look like a real PDF reader app, we use a light grey background 
    // for the "reader" behind the "page" itself.
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF333333),
        foregroundColor: Colors.white,
        elevation: 4,
        title: const Text(
          'Meditations_MarcusAurelius_Book_II.pdf',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 20),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, size: 20),
            onPressed: () {},
          ),
        ],
      ),
      body: InteractiveViewer(
        panEnabled: true,
        scaleEnabled: true,
        minScale: 1.0,
        maxScale: 3.0,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Simulated PDF Page 1
                Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 5,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "BOOK II",
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
                        '''1. Begin the morning by saying to thyself, I shall meet with the busybody, the ungrateful, arrogant, deceitful, envious, unsocial. All these things happen to them by reason of their ignorance of what is good and evil. But I who have seen the nature of the good that it is beautiful, and of the bad that it is ugly, and the nature of him who does wrong, that it is akin to me, not only of the same blood or seed, but that it participates in the same intelligence and the same portion of the divinity, I can neither be injured by any of them, for no one can fix on me what is ugly, nor can I be angry with my kinsman, nor hate him. For we are made for co-operation, like feet, like hands, like eyelids, like the rows of the upper and lower teeth. To act against one another then is contrary to nature; and it is acting against one another to be vexed and to turn away.\n\n2. Whatever this is that I am, it is a little flesh and breath, and the ruling part. Throw away thy books; no longer distract thyself: it is not allowed; but as if thou wast now dying, despise the flesh; it is blood and bones and a network, a contexture of nerves, veins, and arteries. See the breath also, what kind of a thing it is, air, and not always the same, but every moment sent out and again drawn in. The third then is the ruling part: consider thus: Thou art an old man; no longer let this be a slave, no longer be pulled by the strings like a puppet to unsocial movements, no longer be either dissatisfied with thy present lot, or shrink from the future.\n\n3. All that is from the gods is full of providence. That which is from fortune is not separated from nature or without an interweaving and involution with the things which are ordered by providence. From thence all things flow; and there is besides necessity, and that which is for the advantage of the whole universe, of which thou art a part. But that is good for every part of nature which the nature of the whole brings, and what serves to maintain this nature. Now the universe is preserved, as by the changes of the elements so by the changes of things compounded of the elements. Let these principles be enough for thee, let them always be fixed opinions. But cast away the thirst after books, that thou mayest not die murmuring, but cheerfully, truly, and from thy heart thankful to the gods.''',
                        style: TextStyle(
                          fontFamily: 'Times New Roman', // Use a serif font to look like a book
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
                          "14",
                          style: TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Simulated PDF Page 2
                Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 5,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '''4. Remember how long thou hast been putting off these things, and how often thou hast received an opportunity from the gods, and yet dost not use it. Thou must now at last perceive of what universe thou art a part, and of what administrator of the universe thy existence is an efflux, and that a limit of time is fixed for thee, which if thou dost not use for clearing away the clouds from thy mind, it will go and thou wilt go, and it will never return.\n\n5. Every moment think steadily as a Roman and a man to do what thou hast in hand with perfect and simple dignity, and feeling of affection, and freedom, and justice; and to give thyself relief from all other thoughts. And thou wilt give thyself relief, if thou doest every act of thy life as if it were the last, laying aside all carelessness and passionate aversion from the commands of reason, and all hypocrisy, and self-love, and discontent with the portion which has been given to thee. Thou seest how few the things are, the which if a man lays hold of, he is able to live a life which flows in quiet, and is like the existence of the gods; for the gods on their part will require nothing more from him who observes these things.\n\n6. Do wrong to thyself, do wrong to thyself, my soul; but thou wilt no longer have the opportunity of honouring thyself. Every man's life is sufficient. But thine is nearly finished, though thy soul reverences not itself, but places thy felicity in the souls of others.''',
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 160),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "15",
                          style: TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
