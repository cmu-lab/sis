//初期化部
void setup(){
  size(200,200); //サイズ200x200にセット
  background(255); //背景色を白にセット
  colorMode(RGB, 256); //カラーモードをRGB 256段階にセット
  frameRate(30); //フレームレートを30枚/秒にセット
}

//メインループ
void draw(){
  stroke( randomRGBColor()); //線の色をランダムに設定
  int x = int(random(width));
  int y = int(random(height));
  rectLines(x, y, 30, 30); 
}

//ここから関数の定義

void rectLines(int x, int y, int w, int h){
  line (  x,  y,x+w,  y);
  line (  x,  y,  x,y+h);
  line (x+w,  y,x+w,y+h);
  line (x, y+h, x+w, y+h);
}

color randomRGBColor(){
  color c = color(random(256), random(256), random(256), 30);
  return c;
}