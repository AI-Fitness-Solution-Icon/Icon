import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/ai_response.dart';
import '../../../core/widgets/back_button_widget.dart';
import '../bloc/ai_coach_bloc.dart';
import '../bloc/ai_coach_event.dart';
import '../bloc/ai_coach_state.dart';
import '../widgets/chat_message.dart';
import '../widgets/chat_input.dart';
import '../../../navigation/route_names.dart';
import 'package:go_router/go_router.dart';

/// AI Chat screen for interacting with the AI coach
class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AiCoachBloc(),
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButtonWidget(fallbackRoute: '/'),
          title: const Text('AI Coach'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.mic),
              onPressed: () => context.go(RouteNames.voiceInteractionPath),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => context.go(RouteNames.settingsPath),
            ),
          ],
        ),
        body: BlocConsumer<AiCoachBloc, AiCoachState>(
          listener: (context, state) {
            if (state is AiCoachLoaded || state is AiCoachError) {
              _scrollToBottom();
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                // Chat messages
                Expanded(
                  child: _buildChatContent(state),
                ),

                // Loading indicator
                if (state is AiCoachSending)
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 12),
                        Text('AI is thinking...'),
                      ],
                    ),
                  ),

                // Error message
                if (state is AiCoachError)
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<AiCoachBloc>().add(const RetryMessageEvent());
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),

                // Chat input
                ChatInput(
                  onSendMessage: (message) {
                    context.read<AiCoachBloc>().add(SendMessageEvent(message));
                  },
                  isLoading: state is AiCoachSending,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildChatContent(AiCoachState state) {
    if (state is AiCoachInitial) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.psychology,
              size: 64,
              color: AppColors.primary,
            ),
            SizedBox(height: 16),
            Text(
              'Your AI Fitness Coach',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Ask me anything about fitness, nutrition, or workouts!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    // Get messages from state
    List<AIResponse> messages = [];
    if (state is AiCoachLoaded) {
      messages = state.messages;
    } else if (state is AiCoachSending) {
      messages = state.messages;
    } else if (state is AiCoachError) {
      messages = state.messages;
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ChatMessage(
            message: message,
            onTap: () {
              // Handle message tap if needed
            },
          ),
        );
      },
    );
  }
} 