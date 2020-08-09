void main(List<String> args) {
  var t = 'acomsdf@gmail.com';
  t = t.trim();
  t = t.replaceAll(' ', '');
  print(t);
  var x = RegExp(
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
      .hasMatch(t);
  print(x);
  print(t.substring(t.length - 3, t.length));
}
