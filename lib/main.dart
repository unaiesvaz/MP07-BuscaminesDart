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
  List<List<bool>> posicionMinas = [
    [false, false, false, false, false, false, false, false, false, false],
    [false, false, false, false, false, false, false, false, false, false],
    [false, false, false, false, false, false, false, false, false, false],
    [false, false, false, false, false, false, false, false, false, false],
    [false, false, false, false, false, false, false, false, false, false],
    [false, false, false, false, false, false, false, false, false, false],
  ];

    List<List<bool>> posicionFlags = [
      [false, false, false, false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false, false, false, false],
    ];


  final azar = Random();

  colocarMinaCuadrante(posicionMinas, 0, 0, azar);
  colocarMinaCuadrante(posicionMinas, 0, 5, azar);
  colocarMinaCuadrante(posicionMinas, 3, 0, azar);
  colocarMinaCuadrante(posicionMinas, 3, 5, azar);


  bool gameEnded = false;
  bool esPrimeraJugada = true;
  int cantidadFlags = 8;

  while (!gameEnded) {
    printarTablero(tablero, cantidadFlags);
    stdout.write('Escriu una comanda: ');
    String? comanda = stdin.readLineSync();

    if (comanda == null) {
      stdout.writeln('Comanda no vàlida. Torna-ho a provar.');
      continue;
    }

    String orden = comanda.trim().toUpperCase();
    
    int posX = 'ABCDEF'.indexOf(orden[0]);
    int posY = int.parse(orden[1]);

    if (orden.substring(2).trim() == "FLAG" && tablero[posX][posY] == "·") {
      tablero[posX][posY] = "#";
      posicionFlags[posX][posY] = true;
      cantidadFlags -= 1;
    } else if (orden.substring(2).trim() == "FLAG" && tablero[posX][posY] == "#") {
      tablero[posX][posY] = "·";
      posicionFlags[posX][posY] = false;
      cantidadFlags += 1;
    } else {
        bool habiaMina = destapaCasella(tablero, posicionMinas, posX, posY, esPrimeraJugada, true, azar);
        esPrimeraJugada = false;

        if (habiaMina) {
          print("Te has topado con una mina, gg");
          gameEnded = true;
        }
    }

    if (cantidadFlags == 0) {
      int flagsCorrectas = 0;
      for (int i = 0; i < 6; i++) {
        for (int j = 0; j < 10; j++) {
          if (posicionMinas[i][j] == posicionFlags[i][j]) {
            flagsCorrectas += 1;
          }
        }
      }

      gameEnded = true;
      if (flagsCorrectas == 8) {
        print("Has ganado!, has tapado todas las bombas, eres un buscaminas");
      } else {
        print("Has perdido, dedicate a otra cosa porque buscar minas no es lo tuyo");
      }
    }

  }

}

  void printarTablero(List<List<String>> tablero, int cantidadFlags) {
      String fila = "";
      List<String> letras = ['A','B','C','D','E','F'];

      print("Te quedan " + cantidadFlags.toString() + " flags");
      print(" 0123456789");

      for (int i = 0; i < 6; i++) {
        for (int j = 0; j < 10; j++) {
          fila += tablero[i][j];
        }
        print(letras[i] + fila);
        fila = "";
      }
  }


  void colocarMinaCuadrante(List<List<bool>> posicionMinas, int filaInicio, int columnaInicio, Random azar) {
      final azar = Random(); 
      int minasColocadas = 0;

      while (minasColocadas < 2) {
        int filaAleatoria = filaInicio + azar.nextInt(3); // 0, 1, 2
        int columnaAleatoria = columnaInicio + azar.nextInt(5); // 0, 1, 2, 3, 4

        if (posicionMinas[filaAleatoria][columnaAleatoria] == false) {
          posicionMinas[filaAleatoria][columnaAleatoria] = true;
          minasColocadas++;
        }
      }
  }
// Funcion recursiva
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
