class User{
  String username;
  String password;
  String fullName;
  String nickName;
  String avatar;

  User({
    required this.username,
    required this.password,
    required this.fullName,
    required this.nickName,
    required this.avatar,
  });
}

var userList = [
  User(
    username: 'bethharmon',
    password: 'beth123',
    fullName: 'Elizabeth Harmon',
    nickName: 'Beth',
    avatar: 'assets/images/beth-avatar.jpg'
  ),
  User(
    username: 'jonas',
    password: 'jonas123',
    fullName: 'Jonas Kahnwald',
    nickName: 'Jonas',
    avatar: 'assets/images/jonas-avatar.jpg'
  ),
];