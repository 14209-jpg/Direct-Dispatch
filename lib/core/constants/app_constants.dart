class AppConstants {
  // Firestore collections
  static const String usersCollection = 'users';
  static const String requestsCollection = 'requests';
  static const String conversationsCollection = 'conversations';
  static const String messagesCollection = 'messages';

  // Roles
  static const String roleCustomer = 'customer';
  static const String roleAdmin = 'admin';

  // Request statuses — the core lifecycle
  static const String statusPending = 'pending';
  // Admin has seen the request and opened conversation
  static const String statusReviewing = 'reviewing';
  // Admin has confirmed details with customer, going to get workers
  static const String statusConfirmed = 'confirmed';
  // Workers are on their way
  static const String statusDispatched = 'dispatched';
  // Workers arrived, job in progress
  static const String statusInProgress = 'in_progress';
  // Job done, cash collected
  static const String statusCompleted = 'completed';
  // Cancelled for any reason
  static const String statusCancelled = 'cancelled';

  // Pagination
  static const int messagesPageSize = 40;
  static const int requestsPageSize = 30;
}