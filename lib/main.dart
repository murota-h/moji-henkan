import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const KotobaHenkanApp());
}

class KotobaHenkanApp extends StatelessWidget {
  const KotobaHenkanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'もじもじチェンジャー',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const TitlePage(),
    );
  }
}

class TitlePage extends StatelessWidget {
  const TitlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFD6E8), Color(0xFFFFB3D1), Color(0xFFD6B8FF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withValues(alpha: 0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  'assets/images/title.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'もじもじチェンジャー',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB5007A),
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: Colors.white,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'ことばをかわいくへんかんしよ♡',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFD63A8E),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6BAE),
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const HenkanPage()),
                    );
                  },
                  child: const Text(
                    'はじめる ✨',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

class HenkanStyle {
  final String id;
  final String label;
  final String emoji;
  final Color color;
  final String prompt;

  const HenkanStyle({
    required this.id,
    required this.label,
    required this.emoji,
    required this.color,
    required this.prompt,
  });
}

const kStyles = [
  HenkanStyle(
    id: 'keigo',
    label: '敬語・丁寧語',
    emoji: '👩',
    color: Color(0xFF2196F3),
    prompt: 'あなたは日本語の文章を丁寧な敬語・丁寧語に変換するアシスタントです。入力された文章を自然で丁寧な敬語表現に変換してください。変換した文章のみを出力してください。説明や前置きは不要です。',
  ),
  HenkanStyle(
    id: 'gyaru',
    label: 'ギャル語',
    emoji: '💅',
    color: Color(0xFFFF4081),
    prompt: 'あなたは日本語の文章をギャル語に変換するアシスタントです。入力された文章をギャルっぽい口調・スラング・絵文字を使ってノリよく変換してください。変換した文章のみを出力してください。',
  ),
  HenkanStyle(
    id: 'obachan',
    label: 'おばちゃん語',
    emoji: '👵',
    color: Color(0xFFFF9800),
    prompt: 'あなたは日本語の文章をおばちゃん語に変換するアシスタントです。関西弁や世話焼きなおばちゃんっぽい口調、「〜やで」「〜やん」「ほんまに」などの表現を使って変換してください。変換した文章のみを出力してください。',
  ),
  HenkanStyle(
    id: 'kansai',
    label: '関西弁',
    emoji: '🦊',
    color: Color(0xFF4CAF50),
    prompt: 'あなたは日本語の文章を関西弁に変換するアシスタントです。自然な関西弁（大阪弁）に変換してください。変換した文章のみを出力してください。',
  ),
  HenkanStyle(
    id: 'kobun',
    label: '古文・武士語',
    emoji: '⚔️',
    color: Color(0xFF795548),
    prompt: 'あなたは日本語の文章を古文・武士語に変換するアシスタントです。「〜でござる」「〜にて候」「某」などの武士語・古文調の表現に変換してください。変換した文章のみを出力してください。',
  ),
  HenkanStyle(
    id: 'kodomo',
    label: '子ども語',
    emoji: '🐭',
    color: Color(0xFF9C27B0),
    prompt: 'あなたは日本語の文章を子ども語に変換するアシスタントです。幼い子どもが話すような、簡単な言葉・ひらがな多め・かわいい表現に変換してください。変換した文章のみを出力してください。',
  ),
  HenkanStyle(
    id: 'hyojun',
    label: '標準語',
    emoji: '💻',
    color: Color(0xFF607D8B),
    prompt: 'あなたは日本語の文章を標準的な日本語に変換するアシスタントです。方言やスラングを使わない、自然な標準語に変換してください。変換した文章のみを出力してください。',
  ),
];

class HenkanPage extends StatefulWidget {
  const HenkanPage({super.key});

  @override
  State<HenkanPage> createState() => _HenkanPageState();
}

String _simpleConvert(String input, String styleId) {
  var t = input;
  switch (styleId) {
    case 'keigo':
      t = t.replaceAll('ありがとう', 'ありがとうございます');
      t = t.replaceAll('すみません', '大変申し訳ございません');
      t = t.replaceAll('わかった', 'かしこまりました');
      t = t.replaceAll('いい', 'よろしい');
      t = t.replaceAll('だよ', 'でございます');
      t = t.replaceAll('だね', 'ですね');
      t = t.replaceAll('だ。', 'です。');
      t = t.replaceAll('する。', 'いたします。');
      t = t.replaceAll('した。', 'いたしました。');
      t = t.replaceAll('ない。', 'ません。');
      break;
    case 'gyaru':
      t = t.replaceAll('すごい', 'やばい');
      t = t.replaceAll('面白い', 'ウケる');
      t = t.replaceAll('かわいい', 'かわよ〜');
      t = t.replaceAll('ありがとう', 'あざ！');
      t = t.replaceAll('わかった', 'りょ！');
      t = t.replaceAll('でも', 'でもさぁ');
      t = t.replaceAll('だよ', 'だしぃ');
      t = t.replaceAll('だね', 'だよね〜');
      t = t.replaceAll('そう', 'それな');
      t = t.replaceAll('。', '！ 💅');
      break;
    case 'obachan':
      t = t.replaceAll('ありがとう', 'おおきに〜');
      t = t.replaceAll('そう', 'ほんまに');
      t = t.replaceAll('すごい', 'えらいすごい');
      t = t.replaceAll('だよ', 'やで〜');
      t = t.replaceAll('だね', 'やん');
      t = t.replaceAll('です', 'でっせ');
      t = t.replaceAll('ます', 'まっせ');
      t = t.replaceAll('。', '。ほんまに。');
      break;
    case 'kansai':
      t = t.replaceAll('ありがとう', 'おおきに');
      t = t.replaceAll('すごい', 'めっちゃすごい');
      t = t.replaceAll('だよ', 'やで');
      t = t.replaceAll('だね', 'やな');
      t = t.replaceAll('だ。', 'や。');
      t = t.replaceAll('です', 'でんな');
      t = t.replaceAll('ます', 'まっせ');
      t = t.replaceAll('ない', 'ちゃう');
      t = t.replaceAll('そう', 'せやな');
      break;
    case 'kobun':
      t = t.replaceAll('私', '某');
      t = t.replaceAll('あなた', '貴殿');
      t = t.replaceAll('ありがとう', 'かたじけない');
      t = t.replaceAll('すごい', 'これは見事な');
      t = t.replaceAll('わかった', '承知いたした');
      t = t.replaceAll('だ。', 'でござる。');
      t = t.replaceAll('です', 'にて候');
      t = t.replaceAll('ます', 'いたす');
      t = t.replaceAll('した', 'いたした');
      break;
    case 'kodomo':
      t = t.replaceAll('ありがとう', 'ありがとー！');
      t = t.replaceAll('わかった', 'わかったー！');
      t = t.replaceAll('すごい', 'すごーい！');
      t = t.replaceAll('かわいい', 'かわいいー！');
      t = t.replaceAll('です', 'でーす');
      t = t.replaceAll('ます', 'まーす');
      t = t.replaceAll('だよ', 'だよー');
      t = t.replaceAll('。', 'ー！ ');
      break;
    case 'hyojun':
      t = t.replaceAll('やで', 'だよ');
      t = t.replaceAll('やな', 'だね');
      t = t.replaceAll('おおきに', 'ありがとう');
      t = t.replaceAll('せやな', 'そうだね');
      t = t.replaceAll('でんな', 'ですよ');
      t = t.replaceAll('まっせ', 'ます');
      t = t.replaceAll('でっせ', 'です');
      t = t.replaceAll('ちゃう', 'ない');
      break;
  }
  return t;
}

class _HenkanPageState extends State<HenkanPage> {
  final _inputController = TextEditingController();
  HenkanStyle _selectedStyle = kStyles[0];
  bool _isLoading = false;
  String? _result;
  String? _error;
  String _apiKey = '';
  bool _isAiMode = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _apiKey = prefs.getString('api_key') ?? '';
      _isAiMode = prefs.getBool('is_ai_mode') ?? true;
    });
  }

  Future<void> _convert() async {
    final input = _inputController.text.trim();
    if (input.isEmpty) return;

    if (!_isAiMode) {
      setState(() {
        _result = _simpleConvert(input, _selectedStyle.id);
        _error = null;
      });
      return;
    }

    if (_apiKey.isEmpty) {
      setState(() {
        _error = 'APIキーが設定されていません。設定画面から入力してください。';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _result = null;
      _error = null;
    });

    try {
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$_apiKey',
      );
      final body = jsonEncode({
        'system_instruction': {
          'parts': [
            {'text': _selectedStyle.prompt},
          ],
        },
        'contents': [
          {
            'parts': [
              {'text': input},
            ],
          },
        ],
        'generationConfig': {'maxOutputTokens': 1024},
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text =
            data['candidates'][0]['content']['parts'][0]['text'] as String;
        setState(() {
          _result = text.trim();
        });
      } else {
        final data = jsonDecode(response.body);
        final message =
            data['error']?['message'] ?? 'ステータスコード: ${response.statusCode}';
        setState(() {
          _error = 'APIエラー: $message';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'エラーが発生しました: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clear() {
    setState(() {
      _inputController.clear();
      _result = null;
      _error = null;
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFFF6BAE);
    const lightPink = Color(0xFFFFD6E8);
    const textPink = Color(0xFFB5007A);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home_rounded, color: textPink),
          tooltip: 'タイトルへ',
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const TitlePage()),
            );
          },
        ),
        title: const Text(
          'もじもじチェンジャー ✨',
          style: TextStyle(
            color: textPink,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded, color: textPink),
            tooltip: '設定',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
              _loadPrefs();
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFD6E8), Color(0xFFFFF0F6), Color(0xFFEDD6FF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: lightPink, width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: _inputController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: '✏️ 変換したい文章を入力してね',
                        hintStyle: TextStyle(color: Color(0xFFD6A0BC)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '💬 スタイルを選んでね',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textPink,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: lightPink, width: 2),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: kStyles.map((style) {
                      final isSelected = _selectedStyle.id == style.id;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedStyle = style),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? style.color
                                : style.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: style.color,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: style.color.withValues(alpha: 0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            '${style.emoji} ${style.label}',
                            style: TextStyle(
                              color: isSelected ? Colors.white : style.color,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: pink,
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: _isLoading ? null : _convert,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                '✨ 変換する',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textPink,
                        side: const BorderSide(color: pink),
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: _clear,
                      child: const Text('クリア'),
                    ),
                  ],
                ),
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      _error!,
                      style: TextStyle(color: Colors.red.shade800),
                    ),
                  ),
                ],
                if (_result != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: pink, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withValues(alpha: 0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${_selectedStyle.emoji} 変換結果',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: textPink,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy, size: 20, color: pink),
                                tooltip: 'コピー',
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(text: _result!),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('コピーしました 💕'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const Divider(color: lightPink),
                          SelectableText(
                            _result!,
                            style: const TextStyle(fontSize: 16, height: 1.6),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _apiKeyController = TextEditingController();
  bool _isAiMode = true;
  bool _obscure = true;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _apiKeyController.text = prefs.getString('api_key') ?? '';
      _isAiMode = prefs.getBool('is_ai_mode') ?? true;
    });
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_key', _apiKeyController.text.trim());
    await prefs.setBool('is_ai_mode', _isAiMode);
    setState(() => _saved = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _saved = false);
    });
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFFF6BAE);
    const lightPink = Color(0xFFFFD6E8);
    const textPink = Color(0xFFB5007A);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: textPink),
        title: const Text(
          '⚙️ 設定',
          style: TextStyle(color: textPink, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFD6E8), Color(0xFFFFF0F6), Color(0xFFEDD6FF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // モード選択
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: lightPink, width: 2),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🔀 変換モード',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textPink,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _ModeCard(
                        selected: _isAiMode,
                        icon: '🤖',
                        title: 'AIモード',
                        subtitle: 'Gemini AIが高品質に変換\n（APIキーが必要）',
                        onTap: () => setState(() => _isAiMode = true),
                        color: pink,
                      ),
                      const SizedBox(height: 8),
                      _ModeCard(
                        selected: !_isAiMode,
                        icon: '📝',
                        title: 'シンプルモード',
                        subtitle: 'ルールベースで変換\n（APIキー不要・オフライン）',
                        onTap: () => setState(() => _isAiMode = false),
                        color: const Color(0xFF9C27B0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // APIキー入力
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: lightPink, width: 2),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            '🔑 Gemini APIキー',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textPink,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: const Text(
                                  '🔑 APIキーとは？',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFB5007A),
                                  ),
                                ),
                                content: const SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'APIキーは、GeminiのAIを使うための「合言葉」のようなものです。このアプリがAIと話せるようにするために必要です。',
                                        style: TextStyle(height: 1.6),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        '📋 取得方法',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFB5007A),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '① ブラウザで\n「Google AI Studio」\nと検索する\n\n② Googleアカウントでログインする\n\n③ 左メニューの「Get API key」をタップ\n\n④「APIキーを作成」ボタンを押す\n\n⑤ 表示されたキーをコピーして、このアプリの入力欄に貼りつける',
                                        style: TextStyle(height: 1.8),
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        '💡 無料枠があるので、普通に使う分には料金はかかりません。',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          height: 1.6,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  FilledButton(
                                    style: FilledButton.styleFrom(
                                      backgroundColor: const Color(0xFFFF6BAE),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('とじる'),
                                  ),
                                ],
                              ),
                            ),
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF6BAE),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  '?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'AIモード使用時に必要です',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _apiKeyController,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          hintText: 'APIキーを入力',
                          hintStyle: const TextStyle(color: Color(0xFFD6A0BC)),
                          filled: true,
                          fillColor: lightPink.withValues(alpha: 0.3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscure ? Icons.visibility_off : Icons.visibility,
                              color: textPink,
                            ),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: _saved ? Colors.green : pink,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _save,
                  child: Text(
                    _saved ? '✅ 保存しました！' : '💾 保存する',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final bool selected;
  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color color;

  const _ModeCard({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? color : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: selected ? color : Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle_rounded, color: color, size: 22),
          ],
        ),
      ),
    );
  }
}
