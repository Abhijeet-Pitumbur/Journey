String firebaseAuthenticationHandler(String error) {
  switch (error) {
    case "weak-password":
      return "Too weak password";
    case "account-exists-with-different-credential":
    case "email-already-in-use":
      return "Email address already used, sign in instead";
    case "wrong-password":
      return "Invalid password";
    case "user-not-found":
      return "No accounts found with this email adders";
    case "user-disabled":
      return "Account disabled";
    case "operation-not-allowed":
      return "Too many requests to sign into this account";
    case "invalid-email":
      return "Invalid email address";
    default:
      return "Server error";
  }
}
