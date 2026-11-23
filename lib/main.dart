import 'dart:io';
import 'dart:math';

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

  // Posicion de las minas 
  List<List<bool>> posicion_minas = [
    [false, false, false, false, false, false, false, false, false, false],
    [false, false, false, false, false, false, false, false, false, false],
    [false, false, false, false, false, false, false, false, false, false],
    [false, false, false, false, false, false, false, false, false, false],
    [false, false, false, false, false, false, false, false, false, false],
    [false, false, false, false, false, false, false, false, false, false],
  ];

  final azar = Random(); 
  int minasColocadas = 0;

  while (minasColocadas < 2) {
    int filaAleatoria = azar.nextInt(3); // 0, 1, 2
    int columnaAleatoria = azar.nextInt(5); // 0, 1, 2, 3, 4

    if (posicion_minas[filaAleatoria][columnaAleatoria] == false) {
      posicion_minas[filaAleatoria][columnaAleatoria] = true;
      minasColocadas++;
    }
  }



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
