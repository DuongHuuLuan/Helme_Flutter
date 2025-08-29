class AppUser {
  final String uid;
  final String email;
  final String name;
  final String phone;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.phone,
  });

  // lấy thông tin từ firestore
  factory AppUser.fromMap(Map<String, dynamic> data, String uid) {
    return AppUser(
      uid: uid,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
    );
  }

  // chuyển đổi thông tin lên firestore

  Map<String, dynamic> toMap() {
    return {'email': email, 'name': name, 'phone': phone};
  }
}
