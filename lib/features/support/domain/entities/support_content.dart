import 'package:equatable/equatable.dart';

class FaqItem extends Equatable {
  const FaqItem({required this.question, this.answer = ''});

  final String question;
  final String answer;

  @override
  List<Object?> get props => [question, answer];
}

class SupportContent extends Equatable {
  const SupportContent({
    required this.chatReplyTime,
    required this.hotline,
    required this.faqs,
  });

  final String chatReplyTime;
  final String hotline;
  final List<FaqItem> faqs;

  @override
  List<Object?> get props => [chatReplyTime, hotline, faqs];
}
