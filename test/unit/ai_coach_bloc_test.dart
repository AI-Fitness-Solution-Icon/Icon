
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:icon_app/features/ai_coach/bloc/ai_coach_bloc.dart';
import 'package:icon_app/features/ai_coach/bloc/ai_coach_event.dart';
import 'package:icon_app/features/ai_coach/bloc/ai_coach_state.dart';
import 'package:icon_app/core/services/openai_service.dart';
import 'package:icon_app/core/services/supabase_service.dart';
import 'package:mockito/annotations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'ai_coach_bloc_test.mocks.dart';

@GenerateMocks([OpenAIService, SupabaseService, SupabaseClient, GoTrueClient, User])
void main() {
  late AiCoachBloc aiCoachBloc;
  late MockOpenAIService mockOpenAIService;
  late MockSupabaseService mockSupabaseService;
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockGoTrueClient;
  late MockUser mockUser;

  setUp(() {
    mockOpenAIService = MockOpenAIService();
    mockSupabaseService = MockSupabaseService();
    mockSupabaseClient = MockSupabaseClient();
    mockGoTrueClient = MockGoTrueClient();
    mockUser = MockUser();

    when(mockSupabaseService.client).thenReturn(mockSupabaseClient);
    when(mockSupabaseClient.auth).thenReturn(mockGoTrueClient);
    when(mockGoTrueClient.currentUser).thenReturn(mockUser);
    when(mockUser.id).thenReturn('123');

    aiCoachBloc = AiCoachBloc(openAIService: mockOpenAIService, supabaseService: mockSupabaseService);
  });

  tearDown(() {
    aiCoachBloc.close();
  });

  test('initial state is AiCoachInitial', () {
    expect(aiCoachBloc.state, const AiCoachInitial());
  });

  group('SendMessageEvent', () {
    blocTest<AiCoachBloc, AiCoachState>(
      'emits [AiCoachSending, AiCoachLoaded] when message is sent successfully',
      build: () {
        when(mockOpenAIService.chatCompletion(message: 'Hello'))
            .thenAnswer((_) async => {'choices': [{'message': {'content': 'Hi there!'}}]});
        return aiCoachBloc;
      },
      act: (bloc) => bloc.add(const SendMessageEvent('Hello')),
      expect: () => [
        isA<AiCoachSending>(),
        isA<AiCoachLoaded>(),
      ],
    );

    blocTest<AiCoachBloc, AiCoachState>(
      'emits [AiCoachSending, AiCoachError] when message sending fails',
      build: () {
        when(mockOpenAIService.chatCompletion(message: 'Hello'))
            .thenThrow(Exception('Failed to send'));
        return aiCoachBloc;
      },
      act: (bloc) => bloc.add(const SendMessageEvent('Hello')),
      expect: () => [
        isA<AiCoachSending>(),
        isA<AiCoachError>(),
      ],
    );
  });

  group('ClearMessagesEvent', () {
    blocTest<AiCoachBloc, AiCoachState>(
      'emits [AiCoachInitial] when messages are cleared',
      build: () => aiCoachBloc,
      act: (bloc) => bloc.add(const ClearMessagesEvent()),
      expect: () => [const AiCoachInitial()],
    );
  });
}
