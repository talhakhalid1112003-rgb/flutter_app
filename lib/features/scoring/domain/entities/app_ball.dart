import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_ball.freezed.dart';
part 'app_ball.g.dart';

@freezed
abstract class AppBall with _$AppBall {
  const factory AppBall({
    required String ballId,
    required String matchId,
    required String inningsId,
    required int overNumber,
    required int ballNumber, // 1 to 6 usually
    required String batsmanName,
    required String bowlerName,
    required int runs,
    required String? extraType, // 'wide', 'no_ball', 'bye', 'leg_bye', null
    required String? wicketType, // 'bowled', 'caught', 'run_out', etc. null if no wait
    required DateTime timestamp,
  }) = _AppBall;

  factory AppBall.fromJson(Map<String, dynamic> json) => _$AppBallFromJson(json);
}
