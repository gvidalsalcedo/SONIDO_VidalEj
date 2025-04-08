import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
FFT fft;

void setup() {
  size(800, 600);
  minim = new Minim(this);
  song = minim.loadFile("amar_lo_que_siento.mp3", 1024); // tu canción debe llamarse así o cambiar el nombre
  song.play();
  
  fft = new FFT(song.bufferSize(), song.sampleRate());
  fft.logAverages(22, 3);
  noStroke();
  colorMode(HSB, 360, 100, 100);
}

void draw() {
  background(210, 10, 100); // fondo claro (azulado pastel)
  fft.forward(song.mix);
  
  translate(width/2, height/2);
  
  for (int i = 0; i < fft.avgSize(); i++) {
    float angle = map(i, 0, fft.avgSize(), 0, TWO_PI);
    float radius = map(fft.getAvg(i), 0, 50, 50, 300);
    float x = cos(angle) * radius;
    float y = sin(angle) * radius;

    float hue = map(i, 0, fft.avgSize(), 180, 240); // gama azul
    fill(hue, 80, 100, 90);
    ellipse(x, y, 15, 15);
  }
}

void stop() {
  song.close();
  minim.stop();
  super.stop();
}
