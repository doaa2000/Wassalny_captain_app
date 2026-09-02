import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/support_content.dart';
import 'support_remote_data_source.dart';

class SupportSupabaseDataSource implements SupportRemoteDataSource {
  const SupportSupabaseDataSource(this._service);

  final SupabaseService _service;

  @override
  Future<SupportContent> fetchSupportContent() async {
    try {
      final userId = _service.currentUserId;
      if (userId == null) throw const ServerException('No authenticated user');
      return const SupportContent(
        chatReplyTime: 'Typically replies in under 2 min',
        hotline: '19xxx · 24/7',
        faqs: [
          FaqItem(question: 'When do I get paid?'),
          FaqItem(question: 'How are fares calculated?'),
          FaqItem(question: 'Updating my documents'),
          FaqItem(question: 'Acceptance & cancellation rates'),
        ],
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
