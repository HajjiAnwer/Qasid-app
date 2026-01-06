import 'package:flutter/material.dart';

// ------------------ This page is not used any more (Kept as reference) --------------------- //

class PrayerPage extends StatefulWidget {
  const PrayerPage({super.key});

  @override
  State<PrayerPage> createState() => _PrayerPageState();
}

class _PrayerPageState extends State<PrayerPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideRight;
  late Animation<Offset> _slideLeft;
  bool isAr = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _slideRight = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideLeft = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = isAr
        ? 'صفة صلاة النبي ﷺ'
        : 'Description of the Prophet’s (ﷺ) Prayer';

    final List<String> steps = [
      'كان رسول الله ﷺ إذا قام إلى الصلاة، استقبل القبلة، ورفع يديه، واستقبل ببطون أصابعها القبلة، وقال: «الله أكبر».',
      'ثم يمسك شماله بيمينه، ويضعهما على صدره.',
      'ثم يستفتح، ولم يكن يداوم على استفتاح واحد، فكل الاستفتاحات الثابتة عنه يجوز الاستفتاح بها، ومنها: «سبحانك اللهم وبحمدك، وتبارك اسمك، وتعالى جَدُّك، ولا إله غيرك».',
      'ثم يقول: أعوذ بالله من الشيطان الرجيم، بسم الله الرحمن الرحيم.',
      'ثم يقرأ الفاتحة، فإذا ختمها قال: «آمين».',
      'ثم يقرأ ما تيسر من القرآن، ويجهر بالقراءة في الفجر والركعتين الأوليين من المغرب والعشاء، ويسر القراءة فيما سوى ذلك. ويطيل الركعة الأولى من كل صلاة أطول من الثانية.',
      'ثم يرفع يديه كما رفعهما في الاستفتاح، ثم يقول: «الله أكبر»، ويخر راكعًا، ويضع يديه على ركبتيه مفرجتي الأصابع، ويمكنهما، ويمد ظهره، ويجعل رأسه حياله؛ لا يرفعه ولا يخفضه، ويقول: «سبحان ربي العظيم» ثلاث مرات.',
      'ثم يرفع رأسه قائلاً: «سمع الله لمن حمده»، ويرفع يديه كما يرفعها عند الركوع.',
      'فإذا اعتدل قائمًا قال: «اللهم ربنا ولك الحمد، حمداً كثيراً طيبًا مباركًا فيه، ملء السماء، وملء الأرض، وملء ما بينهما، وملء ما شئت من شيء بعد، أهل الثناء والمجد، أحق ما قال العبد، وكلنا لك عبد، لا مانع لما أعطيت، ولا معطي لما منعت، ولا ينفع ذا الجد منك الجد». وكان يطيل هذا الاعتدال.',
      'ثم يكبر ويخر ساجداً، ولا يرفع يديه، ويسجد على جبهته وأنفه ويديه وركبتيه وأطراف قدميه، ويستقبل بأصابع يديه ورجليه القبلة، ويعتدل في سجوده، ويقول في سجوده: «سبحان ربي الأعلى» ثلاثًا.',
      'ثم يرفع رأسه قائلاً «الله أكبر» ثم يفرش رجله اليسرى، ويجلس عليها، وينصب اليمنى، ويضع يديه على فخذيه ثم يقول «اللهم اغفر لي وارحمني، واجبرني، واهدني، وارزقني».',
      'ثم يكبّر ويسجد ويصنع في الثانية مثلما صنع في الأولى.',
      'ثم يرفع رأسه مكبراً، وينهض على صدور قدميه، معتمداً على ركبتيه وفخذيه.',
      'فإذا استتم قائمًا، أخذ في القراءة، ويصلي الركعة الثانية كالأولى.',
      'ثم يجلس للتشهد الأول مفترشًا كما يجلس بين السجدتين، ويقول التشهد: «التحيات لله والصلوات، والطيبات، السلام عليك أيها النبي ورحمة الله وبركاته، السلام علينا وعلى عباد الله الصالحين، أشهد أن لا إله إلا الله، وأشهد أن محمداً عبده ورسوله».',
      'ثم ينهض مكبراً، فيصلي الثالثة والرابعة، ويقرأ فيهما بفاتحة الكتاب فقط.',
      'ثم يجلس في التشهد الأخير متوركًا، والتورك هو: أن يفرش رجله اليسرى ويخرجها من الجانب الأيمن، وينصب اليمنى، ويجعل مقعدته على الأرض.',
      'ثم يتشهد التشهد الأخير، ويزيد عليه: «اللهم صلّ على محمد وعلى آل محمد، كما صليت على آل إبراهيم، إنك حميد مجيد، وبارك على محمد وعلى آل محمد، كما باركت على آل إبراهيم، إنك حميد مجيد».',
      'ويستعيذ بالله من عذاب جهنم، ومن عذاب القبر، ومن فتنة المحيا والممات، ومن فتنة المسيح الدجال، ويدعو بما ورد.',
      'ثم يسلم عن يمينه، فيقول: «السلام عليكم ورحمة الله»، وعن يساره كذلك.',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // الخلفية اليمنى
          SlideTransition(
            position: _slideRight,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Align(
                alignment: Alignment.centerRight,
                child: Opacity(
                  opacity: 0.99,
                  child: Image.asset(
                    'assets/images/masktabs_right.png',
                    fit: BoxFit.cover,
                    width: 280,
                  ),
                ),
              ),
            ),
          ),

          // الخلفية اليسرى
          SlideTransition(
            position: _slideLeft,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Opacity(
                  opacity: 0.99,
                  child: Image.asset(
                    'assets/images/masktabs.png',
                    fit: BoxFit.cover,
                    width: 280,
                  ),
                ),
              ),
            ),
          ),

          // المحتوى
          ListView(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 32),
            children: [
              _sectionTitle(title, const Color(0xFFB77A1F)),
              const SizedBox(height: 16),

              ...List.generate(steps.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${index + 1}. ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Color(0xFF1B7D3B), // الأخضر
                        ),
                      ),
                      Expanded(
                        child: Text(
                          steps[index],
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.7,
                            color: Color(0xFF333333),
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text, Color color) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}
