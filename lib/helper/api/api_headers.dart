class ApiHeader {
// String getToken() {
//   final claimSet = JwtClaim(
//     issuer: issuerName,
//     maxAge: const Duration(minutes: 5),
//     issuedAt: DateTime.now().toUtc(),
//   );
//   String token = issueJwtHS256(claimSet, jwtKey);
//   return token;
// }

  static Map<String, String> get headers => {
        'X-API-KEY': '25F43673DEB6F281A8F2E856902DF98D',
        'Accept': 'application/json',
        // 'Authorization': 'Bearer ${getToken()}',
        // 'Authorization':
        //     'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2ODQ1NjI4NjUsImlzcyI6ImVzaG9wIiwiZXhwIjoxNjg0NTY0NjY1fQ.0FFtp99RTlxC694gpceYl1EmEM4ZfsPz24ClXZ8BGlo',
      };
}
