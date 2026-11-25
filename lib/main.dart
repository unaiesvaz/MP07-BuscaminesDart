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

  bool gameEnded = false;
  while (!gameEnded) {
    stdout.write('Escriu una comanda: ');
    String? comanda = stdin.readLineSync();
    
    if (comanda == null || comanda.length > 2) {
      stdout.writeln('Comanda no vàlida. Torna-ho a provar.');
      continue;
  }



  }
}

int comptaMinesAdjacents(
  List<List<bool>> posicionMinas,
  int fila,
  int columna,
) {
  int total = 0;

  for (int cambioFila = -1; cambioFila <= 1; cambioFila++) {
    for (int cambioColumna = -1; cambioColumna <= 1; cambioColumna++) {
      if (cambioFila == 0 && cambioColumna == 0) {
        continue; // No contar la casilla central
      }

      int filaVecina = fila + cambioFila;
      int columnaVecina = columna + cambioColumna;

      bool dentroDelTablero =
          filaVecina >= 0 &&
          filaVecina < posicionMinas.length &&
          columnaVecina >= 0 &&
          columnaVecina < posicionMinas[filaVecina].length;

      if (dentroDelTablero && posicionMinas[filaVecina][columnaVecina]) {
        total++;
      }
    }
  }

  return total;
}

void mouBomba(
  List<List<bool>> posicionMinas,
  List<List<String>> tablero,
  int filaAntigua,
  int columnaAntigua,
  Random azar,
) {
  int filaNueva;
  int columnaNueva;

  do {
    filaNueva = azar.nextInt(posicionMinas.length);
    columnaNueva = azar.nextInt(posicionMinas[filaNueva].length);
  } while (
      posicionMinas[filaNueva][columnaNueva] ||
      tablero[filaNueva][columnaNueva] != '·');

  posicionMinas[filaAntigua][columnaAntigua] = false;
  posicionMinas[filaNueva][columnaNueva] = true;
}

bool destapaCasella(
  List<List<String>> tablero,
  List<List<bool>> posicionMinas,
  int fila,
  int columna,
  bool esPrimeraJugada,
  bool esJugadaUsuario,
  Random azar,
) {
  // Si está fuera del tablero, ya está destapada o tiene bandera.
  if (fila < 0 ||
      fila >= tablero.length ||
      columna < 0 ||
      columna >= tablero[fila].length ||
      tablero[fila][columna] != '·') {
    return false;
  }

  // Si hay mina, se aplica la regla correspondiente.
  if (posicionMinas[fila][columna]) {
    if (esPrimeraJugada) {
      mouBomba(posicionMinas, tablero, fila, columna, azar);
      // La mina se ha movido; seguimos y destapamos esta casilla.
    } else if (esJugadaUsuario) {
      return true; // El jugador ha elegido una mina: explotó.
    } else {
      return false; // Una mina vecina no detiene la expansión recursiva.
    }
  }

  int numero = comptaMinesAdjacents(posicionMinas, fila, columna);

  // Un espacio representa una casilla vacía; los demás muestran el número.
  tablero[fila][columna] = numero == 0 ? ' ' : numero.toString();

  if (numero == 0) {
    for (int cambioFila = -1; cambioFila <= 1; cambioFila++) {
      for (int cambioColumna = -1;
          cambioColumna <= 1;
          cambioColumna++) {
        if (cambioFila == 0 && cambioColumna == 0) {
          continue;
        }

        destapaCasella(
          tablero,
          posicionMinas,
          fila + cambioFila,
          columna + cambioColumna,
          false,
          false,
          azar,
        );
      }
    }
  }

  return false; // Esta jugada no explotó.
}
