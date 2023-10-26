import 'package:envied/envied.dart';

part 'env2.g.dart';

@Envied(path: '.env')
abstract class Env2 {
  @EnviedField(varName: 'OPENAI_API_KEY')
  static const String apiKey = _Env2.apiKey;
}
