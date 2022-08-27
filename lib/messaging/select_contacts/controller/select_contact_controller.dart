import 'package:bbk_final_ana/messaging/select_contacts/repository/select_contact_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getUserContactsProvider = FutureProvider((ref) {
  final selectContactRepository = ref.watch(selectContactRepositoryProvider);
  return selectContactRepository.getUserContacts();
});
