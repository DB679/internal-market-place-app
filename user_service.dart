class UserService {
  UserService._private();
  static final UserService instance = UserService._private();

  // In a real app these would come from authentication/profile storage.
  String get name => 'Current User';
  String get contact => 'current.user@example.com';

  bool get isLoggedIn => true;
}
