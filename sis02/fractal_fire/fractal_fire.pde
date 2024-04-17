// フラクタルでたき火をしましょう

void setup(){
  size(400,400);
  colorMode(RGB); //RGB色空間にセット
  background(0); //背景は黒にセット
  frameRate(10);
}

 float f1 = 0.0;
 
void draw(){

  int fire_int;
  
  f1 = f1 + 0.1;
  
  fire_int = int(abs(255 * sin(f1)));
  fill(fire_int, 0, 0);
  
  rect(150, 150, 100, 100);

}

