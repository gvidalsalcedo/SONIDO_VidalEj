import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
FFT fft;

int numWaves = 5;
float waveDetail = 0.02;
float waveHeight = 50;

color dayColor;
color sunsetColor;
color nightColor;

boolean showStars = false;
PVector[] stars;

void setup() {
  size(800, 600);
  minim = new Minim(this);
  song = minim.loadFile("amar_lo_que_siento.mp3", 1024); // asegúrate de que el archivo esté en la carpeta "data"
  song.play();
  
  fft = new FFT(song.bufferSize(), song.sampleRate());
  fft.logAverages(22, 3);
  
  colorMode(HSB, 360, 100, 100);
  noStroke();
  
  dayColor = color(210, 10, 100);    // Azul claro (día)
  sunsetColor = color(30, 80, 100);  // Naranja-rosado (atardecer)
  nightColor = color(240, 80, 10);   // Azul oscuro (noche)

  // Estrellas
  stars = new PVector[100];
  for (int i = 0; i < stars.length; i++) {
    stars[i] = new PVector(random(width), random(height / 2));
  }
}

void draw() {
  float currentTime = song.position() / 1000.0; // en segundos
  float t = constrain(map(currentTime, 60, 90, 0, 1), 0, 1); // transición suave entre 60 y 90 segundos
  color bgColor = lerpColor(dayColor, sunsetColor, t); // de día a atardecer

  if (currentTime > 90) {
    float n = constrain(map(currentTime, 90, 120, 0, 1), 0, 1); // transición hacia noche
    bgColor = lerpColor(sunsetColor, nightColor, n);
    showStars = true;
  }

  background(bgColor);

  fft.forward(song.mix);

  // Dibujar estrellas si es de noche
  if (showStars) {
    fill(60, 10, 100, 90); // blanco cálido
    for (PVector star : stars) {
      ellipse(star.x, star.y, 2, 2);
    }
  }

  // Dibujar olas
  for (int j = 0; j < numWaves; j++) {
    float offsetY = height - j * 40;
    float brightness = map(j, 0, numWaves, 100, 40);
    float amplitude = map(fft.getAvg(j), 0, 50, 10, waveHeight);

    fill(200 + j*5, 80, brightness, 80); // tonos de azul
    beginShape();
    vertex(0, height);
    for (float x = 0; x <= width; x += 10) {
      float y = offsetY + sin(x * waveDetail + frameCount * 0.03 + j) * amplitude;
      vertex(x, y);
    }
    vertex(width, height);
    endShape(CLOSE);
  }
}

void stop() {
  song.close();
  minim.stop();
  super.stop();
}
