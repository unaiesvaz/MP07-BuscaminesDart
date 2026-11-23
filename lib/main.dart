import 'dart:io';

void main() {
  stdout.writeln('Buscamines');
  stdout.writeln('Escriu help per veure les comandes.');

  List<List<String>> tablero = [
    ['·', '·', '·', '·', '·', '·', '·', '·', '·', '·'],
    ['·', '·', '·', '·', '·', '·', '·', '·', '·', '·'],
    ['·', '·', '·', '·', '·', '·', '·', '·', '·', '·'],
    ['·', '·', '·', '·', '·', '·', '·', '·', '·', '·'],
    ['·', '·', '·', '·', '·', '·', '·', '·', '·', '·'],
    ['·', '·', '·', '·', '·', '·', '·', '·', '·', '·'],
  ];

  String fila = "";
  List<String> letras = ['A','B','C','D','E','F'];

  print(" 0123456789");

  for (int i = 0; i < 6; i++) {
    for (int j = 0; j < 10; j++) {
      fila += tablero[i][j];
    }
    print(letras[i] + fila);
    fila = "";
  }

  


}
