// ignore_for_file: avoid_field_initializers_in_const_classes

class Env {
  const Env._();
  static const Env instance = Env._();
  final String sentryDns = const String.fromEnvironment(
    'sentry_dns',
    defaultValue: '',
  );
  final String tankerKoenigToken = const String.fromEnvironment(
    'tanker_koenig',
    defaultValue: 'c2e9b4de-1aa2-22eb-3284-a24b4cf1a9fd',
  );
}
