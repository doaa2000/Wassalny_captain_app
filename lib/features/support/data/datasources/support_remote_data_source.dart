import '../../domain/entities/support_content.dart';

abstract interface class SupportRemoteDataSource {
  Future<SupportContent> fetchSupportContent();
}

/// In-memory support content seeded from the design.
class SupportLocalDataSource implements SupportRemoteDataSource {
  @override
  Future<SupportContent> fetchSupportContent() async => const SupportContent(
        chatReplyTime: 'Typically replies in under 2 min',
        hotline: '19xxx · 24/7',
        faqs: [
          FaqItem(question: 'When do I get paid?'),
          FaqItem(question: 'How are fares calculated?'),
          FaqItem(question: 'Updating my documents'),
          FaqItem(question: 'Acceptance & cancellation rates'),
        ],
      );
}
