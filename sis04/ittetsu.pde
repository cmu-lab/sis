// Kantou Transport Simulator ?
// 2010.09.22  by Hajime Nobuhara

int Length = 800;
int Max_Bus = 4; //バスの数
int Max_Bus_stop = 3; //バス停の数
int[][] X = new int[Length][1];
Bus[] myBus = new Bus[Max_Bus];
Bus_stop[] myBus_stop = new Bus_stop[Max_Bus_stop];

int sim_time = 0;

void setup() {
  size(800,100);
  smooth();
  background(0);

  frameRate(20);

  for(int i=0; i < Max_Bus; i++){
    float k1 = random(255);
    float k2 = random(255);
    float k3 = random(255);
    color tempcolor = color(k1,k2,k3);
    int k4 = 3; //最高スピード
    int k5 = 1; //初期スピード
    int k6 = 0; // waitのフラグ
    myBus[i] = new Bus(tempcolor,Length/Max_Bus*i,55,k4,k5,k6,0);
  }

   for(int i=0; i < Max_Bus_stop; i++){
    int k1 = int(random(5)+1);
    myBus_stop[i] = new Bus_stop(Length/(Max_Bus_stop+1)*(i+1),1,k1);
  }

  for(int i=0; i< Length; i++){
    X[i][0] = 0;
  }
}



void draw() {

  //まずは背景を描画しましょう
  background(100,100,250);
  draw_background();
  draw_sky();

  //各バスを動かします
   for(int j=0; j < Max_Bus; j++){
    println(myBus[j].wait_flag);

     if(myBus[j].wait_flag <= 0){
       myBus[j].draw();
       myBus[j].drive();
       myBus[j].breaking();
       myBus[j].check();
     }
     else{
       myBus[j].waiting();
       myBus[j].draw();
     }
   }

  //各バス停を描画します
  //待っている人数を描画

  for(int j=0; j < Max_Bus_stop; j++){
     myBus_stop[j].draw();
  }
   sim_time++;

}


class Bus_stop
{
  int xpos;
  int ypos;
  int number;
  int j;

  Bus_stop(int xp, int yp, int num) {
    xpos = xp;
    ypos = yp;
    number = num;
  }

  void draw () {
    fill(200);
    ellipse(xpos,ypos+30,15,15);
    rect(xpos-1,ypos+30,3,20);

    for(j=0;j<number;j++){
      fill(0,255,0);
      rect(xpos+(j+1)*5,ypos+40,3,10);
      ellipse(xpos+(j+1)*5+1,ypos+40,6,6);
    }
  }
}



// バスのクラス

class Bus
{
  color c; //バスの色
  int xpos; //バスのx座標
  int ypos; //バスのy座標
  int Max_Speed; //バスの最高速度
  int xvel; //バスの現在の速度
  int wait_flag; //バス停にストップするときのフラグ
  int stop_number; //バス停に並んでいる人数 = バスの乗せる人数

  //バスを初期化
  Bus(color c_, int xp, int yp, int mx, int xv, int w, int num) {
    c = c_;
    xpos = xp;
    ypos = yp;
    Max_Speed = mx;
    xvel = xv;
    wait_flag = w;
    stop_number = num;
  }

  //バスを描画
  void draw () {

    //車体を描画
    stroke(0);
    fill(c);
    rect(xpos,ypos,30,15);

    //窓を描画
    fill(255);
    rect(xpos+2,ypos+2,5,5);
    rect(xpos+7,ypos+2,5,5);
    rect(xpos+12,ypos+2,5,5);
    rect(xpos+17,ypos+2,5,5);
    rect(xpos+24,ypos+2,5,5);

    //タイヤを描画
    fill(0);
    ellipse(xpos+6,ypos+15,8,8);
    ellipse(xpos+24,ypos+15,8,8);

    //タイヤのホイール部分を描画
    fill(255);
    ellipse(xpos+6,ypos+15,5,5);
    ellipse(xpos+24,ypos+15,5,5);

    //排気ガスの様子を描画
    if((sim_time%3)==0){
      noStroke();
      fill(255,100);
      ellipse(xpos-6,ypos+15,8,8);
    }
     if((sim_time%3)==1){
       noStroke();
       fill(255,60);
      ellipse(xpos-6,ypos+15,7,7);
    }
     if((sim_time%3)==2){
       noStroke();
       fill(255,30);
      ellipse(xpos-6,ypos+15,5,5);
    }
  }

  // バスを動かします

  void drive () {

      //前方にバスがいるかどうかを判定
      int k = 0;
      for(int i = xpos + 1; i < xpos + 15; i++){
        k = k + X[(i + width) % width][0];
      }

      //バスが存在する場合は，k が1以上になる．
      //存在しなければ k は 0

      if(k == 0) {
        xvel = xvel + 2;
        if(xvel > Max_Speed){
          xvel = Max_Speed;
        }
      }

      //自分自身の位置を更新
      X[xpos][0] = 0;
      xpos = (xpos + xvel + width) % width;
      X[xpos][0] = 1;
  }

  // ブレーキの判定
  void breaking (){
    //もし前方に何かがあれば，速度をゆるめる
    for(int i = xpos + 1; i < xpos + 50; i++){
      if(X[(i+width)%width][0] == 1){
        xvel = xvel - 2;
        if(xvel < 0) xvel = 0;
      }
    }
  }

  void check(){
    for(int i = 0; i < Max_Bus_stop; i++){
      println(myBus_stop[i].xpos);
      if((abs(xpos - myBus_stop[i].xpos))<50){
        xvel = xvel - 3;
        if(xvel < 0) xvel = 0;
      }

      if(abs(xpos - myBus_stop[i].xpos)<2){
          wait_flag = 10*myBus_stop[i].number;
          stop_number = i;
      }

    }
  }

  void waiting(){
    wait_flag--;
    println(wait_flag);
    xvel = 0;
    if(wait_flag<10){
     xvel = 3;
    }
    if(wait_flag == 0){
      myBus_stop[stop_number].number = int(random(5)+1);
    }

  }

}



//背景を描きます
void draw_background(){
  noStroke();

  //道路を描きます
  fill(150,150,150);
  rect(0,50,Length,80);

  //白線を描きます
  for(int j=0; j < 40; j++){
    fill(255,255,255);
    rect(0+j*20,90,15,2);
  }

}


//空を描く関数
void draw_sky(){
  noStroke();

  //雲を描きます
  fill(255,200);
  int xpos = (sim_time % (2*Length))/ 2;
  ellipse(xpos,20,40,20);
  ellipse(xpos+30,20,40,20);

  xpos = ((sim_time + 500) % (2*Length))/ 2;
  ellipse(xpos,20,40,20);
  ellipse(xpos+30,20,40,20);

  //遠くの雲を描きます
  xpos = ((sim_time + 2000) % (2*Length))/ 4;
  ellipse(xpos,10,20,10);
  ellipse(xpos+15,10,20,10);

  //太陽を描きます
  xpos = ((sim_time + 700) % Length);
  fill(255,255,0);
  ellipse(xpos,20,20,20);

}

//マウスを押すとその画面がキャプチャできます
void mousePressed() {
 saveFrame("sample");
}
