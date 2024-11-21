import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/api_service.dart';
import 'playlist_screen.dart';

class MixScreen extends StatefulWidget {
  const MixScreen({super.key});

  @override
  _MixScreenState createState() => _MixScreenState();
}

class _MixScreenState extends State<MixScreen> {
  String selectedExercise = '선택하기';
  String selectedTime = '입력하기';

  void generatePlaylist(BuildContext context) async {
    if (selectedExercise == '선택하기' || selectedTime == '입력하기') {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('입력 오류'),
            content: Text('운동 종류와 시간을 모두 입력해주세요.'),
          );
        },
      );
      return;
    }

    try {
      showLoadingDialog(context); // 로딩 화면 표시
      final playlist = await ApiService.fetchPlaylist(
          selectedExercise, selectedTime); // ApiService 호출

      Navigator.of(context).pop(); // 로딩 팝업 닫기
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlaylistScreen(
          playlistName: selectedExercise,
          tracks: playlist['tracks'],
        ),
      ));
    } catch (e) {
      Navigator.of(context).pop(); // 로딩 팝업 닫기
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('오류 발생'),
            content: Text('플레이리스트 생성 중 오류가 발생했습니다: $e'),
          );
        },
      );
    }
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: SpinKitWave(
            color: Color(0xff777777),
            size: 30,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xffffffff),
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Image.asset(
            'assets/images/arrow.png',
            width: 24,
            height: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 24.0),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/mix_image.png',
                    width: 166,
                    height: 174,
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'AI가 만들어주는\n나만의 음악 믹스',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '단 30초면 음악을 고르는 \n번거로움 없이 나만의 플레이리스트가 자동 생성돼요.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Color(0xff777777),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xffefefef),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 13.0, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '운동 종류',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff111111),
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: const Color(0xffffffff),
                                    title: const Text('운동 종류 선택',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff111111),
                                        )),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          title: const Text('런닝'),
                                          onTap: () {
                                            setState(() {
                                              selectedExercise = 'running';
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ListTile(
                                          title: const Text('웨이트'),
                                          onTap: () {
                                            setState(() {
                                              selectedExercise = 'weight';
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ListTile(
                                          title: const Text('요가'),
                                          onTap: () {
                                            setState(() {
                                              selectedExercise = 'yoga';
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ListTile(
                                          title: const Text('필라테스'),
                                          onTap: () {
                                            setState(() {
                                              selectedExercise = 'pilates';
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ListTile(
                                          title: const Text('클라이밍'),
                                          onTap: () {
                                            setState(() {
                                              selectedExercise = 'climbing';
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ListTile(
                                          title: const Text('사이클링'),
                                          onTap: () {
                                            setState(() {
                                              selectedExercise = 'cycling';
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Text(
                              selectedExercise == '선택하기'
                                  ? '선택하기'
                                  : selectedExercise,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff777777),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xffefefef),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 13.0, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '운동 시간',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff111111),
                            ),
                          ),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                selectedTime = value;
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: '입력하기',
                              suffixText: '분',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff777777),
                              ),
                              suffixStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff777777),
                              ),
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Color(0xffefefef),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff777777),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xff111111),
                      borderRadius: BorderRadius.circular(500),
                    ),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () => generatePlaylist(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        child: const Text(
                          '생성하기',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xffffffff),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
