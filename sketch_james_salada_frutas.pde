import ddf.minim.*;

Minim minim;
AudioPlayer somAquiTaMao, somCapricho, somEsseEJames, somObrigado, somHabilidade, somOhJames;

int pontuacao = 0;
int ultimoPego = 0;
int tempoUltimoAudio = 0;

// Imagens
PImage james_frutas_esquerda, james_frutas_direita, rua;
PImage jamesAtual; // imagem do james inicial
PImage banana, manga, uva, kiwi, mamao, leite;

ArrayList<Fruta> frutas = new ArrayList<Fruta>();
PImage[] imagensFrutas;

// Posição e direção do James
float xjames_frutas = 350;
float yjames_frutas = 430;
float velocidade = 8;
boolean indoDireita = true;

void setup () {
  size (800, 580);
  
  // carregando imagens
  james_frutas_esquerda = loadImage("james_frutas_esquerda.png");
  james_frutas_direita = loadImage("james_frutas_direita.png");
  jamesAtual = james_frutas_esquerda;
  rua = loadImage("rua.png");
  banana = loadImage("banana.png");
  manga = loadImage("manga.png");
  uva = loadImage("uva.png");
  kiwi = loadImage("kiwi.png");
  mamao = loadImage("mamao.png");
  leite = loadImage("leite.png");

  imagensFrutas = new PImage[] {banana, manga, uva, kiwi, mamao, leite};

  minim = new Minim(this);

  somAquiTaMao = minim.loadFile("aqui-ta-mao.mp3");
  somCapricho = minim.loadFile("capricho.mp3");
  somEsseEJames = minim.loadFile("esse-e-james.mp3");
  somObrigado = minim.loadFile("obrigado-james.mp3");
  somHabilidade = minim.loadFile("habilidade.mp3");
  somOhJames = minim.loadFile("oh-james.mp3");

  somCapricho.play(); // intro
}

boolean colidiuComJames(Fruta fruta) {
  return fruta.x + 50 > xjames_frutas && fruta.x < xjames_frutas + 150 &&
         fruta.y + 50 > yjames_frutas && fruta.y < yjames_frutas + 150;
}

void draw() {
  background(255);
  image(rua, 0, 0, width, height);

  // Gera frutas
  if (frameCount % 30 == 0) {
    PImage frutaAleatoria = imagensFrutas[int(random(imagensFrutas.length))];
    float xAleatorio = random(50, width - 50);
    frutas.add(new Fruta(frutaAleatoria, xAleatorio));
  }

  // Atualiza e desenha as frutas
  for (int i = frutas.size() - 1; i >= 0; i--) {
    Fruta f = frutas.get(i);
    f.mover();
    f.mostrar();

    if (colidiuComJames(f)) {
      frutas.remove(i);
      pontuacao++;
      tocarSomAleatorio();
    } else if (f.saiuDaTela()) {
      frutas.remove(i);
    }
  }

  // Desenha James
  image(jamesAtual, xjames_frutas, yjames_frutas, 150, 150);

  //Movimento controlado pelo teclado do usuário
  if (keyPressed) {
  if (keyCode == LEFT && xjames_frutas > 0) {
    xjames_frutas -= velocidade;
    jamesAtual = james_frutas_esquerda;
  } else if (keyCode == RIGHT && xjames_frutas < width - 150) {
    xjames_frutas += velocidade;
    jamesAtual = james_frutas_direita;
  }
}

  // Mostra pontuação
  fill(255);
  textSize(24);
  text("Pontuação: " + pontuacao, 20, 40);
}

void tocarSomAleatorio() {
  // Só toca se já passaram 1.5 segundos desde o último
  if (millis() - tempoUltimoAudio < 1500) return;

  int sorteio = int(random(6));
  AudioPlayer som = null;

  switch(sorteio) {
    case 0: som = somAquiTaMao; break;
    case 1: som = somEsseEJames; break;
    case 2: som = somObrigado; break;
    case 3: som = somHabilidade; break;
    case 4: som = somOhJames; break;
    case 5: som = somCapricho; break;
  }

  if (som != null) {
    som.rewind(); // garante que toque do começo
    som.play();
    tempoUltimoAudio = millis();
  }
}

class Fruta {
  PImage imagem;
  float x, y;
  float velocidade;

  Fruta(PImage img, float xInicial) {
    imagem = img;
    x = xInicial;
    y = -50;
    velocidade = random(3, 6);
  }

  void mover() {
    y += velocidade;
  }

  void mostrar() {
    image(imagem, x, y, 50, 50);
  }

  boolean saiuDaTela() {
    return y > height;
  }
}
