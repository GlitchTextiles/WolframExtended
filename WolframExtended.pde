import java.util.BitSet;
import java.util.Arrays;

int page;
boolean changeRule = true;
boolean scroll = true;
boolean save = false;
int shift = 0;
int qty_neighbors = 3;
int qty_colors =int(pow(2, qty_neighbors));
int counter_shift = 0;
boolean jam = false; //force an input
String thePath;
String rulesPreset = new String("0001001100001010101001001101110010101011010011001001001110110100");
boolean loadRulesPreset = false;
PImage design;
int w = 480;
int h = 270;
color[] colors;
int scale = 1;

int qty_neighbor_combinations = int(pow(2, qty_neighbors));

Register generation;
Register rules;

void setup() {
  size(0, 0);
  surface.setSize(w, h);
  design = createImage(w, h, RGB);
  initRules();

  generation = new Register(design.width);
  generation.randomize();

  generatePalette(1);
  ;

  for (int i = 0; i < design.height; i++) {
    updateDesign(scroll);
  }

  noSmooth();
}

void draw() {
  updateDesign(scroll);
  image(design, 0, 0, width, height);
  //  saveFrame("output/CA_BW_001/CA_BW_001-####.PNG");
  //  if(frameCount >= 5000){
  //    exit();
  //  }
}

void initRules() {
  rules = new Register(qty_neighbor_combinations);
  for (int i = 0; i < rules.size(); i++) {
    if (loadRulesPreset) {
      if (rulesPreset.charAt(rules.size()-1-i) == 48) {
        rules.set(i, false);
      } else if (rulesPreset.charAt(rules.size()-1-i) == 49) {
        rules.set(i, true);
      }
    } else {
      rules.set(i, randomBit());
    }
  }
}

boolean randomBit() {
  return random(1) <= 0.5;
}

void generatePalette(int mode) {

  colors = new color[qty_neighbor_combinations];

  switch(mode) {

  case 0: //linear gradient
    color colorA = color(random(256), random(256), random(256));
    color colorB = color(random(256), random(256), random(256));
    for (int i = 0; i < colors.length; i++) {
      colors[i] = lerpColor(colorA, colorB, float(i)/float(colors.length-1));
    }
    break;

  case 1: //random colors
    for (int i = 0; i < colors.length; i++) {
      colors[i] = color(random(256), random(256), random(256));
    }
    break;
  }
}

void updateDesign(boolean scroll) {
  design.loadPixels();
  if (!scroll) {
    for (int i = 0; i < design.height; i++) {
      drawGeneration(i);
      applyRules(countNeighbors());
    }
  } else {
    shiftUp();
    applyRules(countNeighbors());
    drawGeneration(design.height-1);
  }
  design.updatePixels();
}

void keyReleased() {
  switch(key) {
  case 'j':
    jam = false;
    break;
  }
}

void keyPressed() {
  switch(key) {
  case 'v':
    generatePalette(0);
    break;
  case 'b':
    generatePalette(1);
    break;
  case 'd':
    rules.inv();
  case 'f':
    rules.rev();
    break;
  case 'x':
    generation.clear();
    break;
  case 'c':
    generation.clear();
    generation.set(int(generation.size()/2), true);
    break;
  case 'j':
    jam = true;
    break;
  case 'r': 
    generation.randomize();
    break;
  case 's':
    rules.inc();
    rules.debug();
    break;
  case 'a':
    rules.dec();
    rules.debug();
    break;
  case 'q':
    generation.shiftLeft(generation.get(0));
    break;
  case 'w':
    generation.shiftRight(generation.get(generation.size()-1));
    break;
  case'-':
    shift--;
    println("shift: " + shift);
    break;
  case'=':
    shift++;
    println("shift: " + shift);
    break;
  case 'p':
    rules.randomize();
    println("shift: " + shift);
    break;
  case 'o':
    save_file();
    break;
  case',':
    rules.shiftLeft(rules.get(rules.size()-1));
    rules.debug();
    break;
  case'.':
    rules.shiftRight(rules.get(0));
    rules.debug();
    break;
  case 'z':
    rules.clear();
    break;
  case'[':
    //rules.shiftLeft(rules.data[rules.data.length-2]^rules.data[rules.data.length-1]);
    break;
  case']':
    //rules.shiftRight(rules.data[0]^rules.data[1]);
    break;
  }
  redraw();
}

void save_file() {
  selectOutput("Select a file to process:", "outputSelection");
}

void outputSelection(File output) {
  if (output == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + output.getAbsolutePath());
    thePath = output.getAbsolutePath();
    saveData(thePath);
  }
}

void saveData(String _thePath) {
  design.save(_thePath + "_" + rules.toString() + "_" + shift +".PNG");
  println("Done Saving! " + _thePath);
  save = false;
}

void drawGeneration(int _y) {
  int[] states = countNeighbors();
  for (int x = 0; x < design.width; x++) {
    design.pixels[_y * design.width+x] = color(255*int(generation.get(x)));
    //    design.pixels[_y * design.width+x] = colors[states[x]];
  }
}



void shiftUp() {
  for (int i = 0; i < design.pixels.length-design.width; i++) {
    design.pixels[i] = design.pixels[i+design.width];
  }
}

int[] countNeighbors() { 
  int[] state = new int[design.width];
  for (int i = 0; i < design.width; i++) {
    for (int n = 0; n < qty_neighbors; n++) {
      int coord = ((i + shift) + design.width + (n - int(qty_neighbors/2))) % design.width;
      state[i] |= int(generation.get(coord)) << ((qty_neighbors-1) - n);
    }
  }
  return state;
}

void applyRules(int[] _states) {
  for (int i = 0; i < design.width; i++) {
    generation.set(i, rules.get(_states[i]));
  }
}
