//初期化部
void setup(){
  size(200,200); //サイズ200x200にセット
  background(255); //背景色を白にセット
  colorMode(RGB, 256); //カラーモードをRGB 256段階にセット
  noStroke(); //図形に輪郭線をつけない
  frameRate(15); //フレームレートを30枚/秒にセット
}

//メインループ
void draw(){
  
  fadeToWhite(); //画面を白にフェードアウトさせる

  int x = int(random(width));
  int y = int(random(height));
  int sz = int(random(100));
  
  fill(randomRGBColor());
  ellipse(x, y, sz, sz);
}

//ここから関数の定義
color randomRGBColor(){
  color c = color(random(256), random(256), random(256), 30);
  return c;
}

//画面を白にフェードアウトする関数
void fadeToWhite(){
  rectMode(CORNER);
  fill(255,30);
  rect(0,0,width,height);
}