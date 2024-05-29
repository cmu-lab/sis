//マルチエージェントによる戦国シミュレーション
//佐藤軍 vs 澤勢軍
//画面中に数を表示


int Length = 500; //空間管理配列の大きさ Lengthの大きさの正方形が戦場
int Max_sato = 33; //佐藤軍の最大数
int Max_sawase = 100; //澤勢軍の最大数

int[][] MAP = new int[Length][Length];  //空間配列を準備
Human[] sato = new Human[Max_sato];  //佐藤軍を準備
Human[] sawase = new Human[Max_sawase];  //澤勢軍を準備


//初期化部
void setup() {
  colorMode(HSB);
  size(Length,Length); 
  background(0);
  frameRate(30);

  PFont font = loadFont("AgencyFB-Reg-24.vlw");
  textFont(font);


  //ここで佐藤軍を生成
  for(int i=0; i < Max_sato; i++){
     int k1 = 1; //生きている人間の状態を1、死んでいる場合は 0
     int k2 = int(random(width)); //登場する初期 x座標
     //int k3 = int(random(height)); 登場する初期 y座標
     int k3 = int(random(10)) + 50; //登場する初期 y座標
     
     int k4 = int(2.0 * (random(10) + 10)); //体力の設定
     sato[i] = new Human(k1,k2,k3,k4);
  }
  
  //ここで澤勢軍を生成
  for(int i=0; i < Max_sawase; i++){
     int k1 = 2; //生きている人間の状態を2、死んでいる場合は 0
     int k2 = int(random(width)); //登場する初期 x座標
     // int k3 = int(random(height)); 登場する初期 y座標
     int k3 = height - int(random(10) + 50); //登場する初期 y座標
     int k4 = int(random(10) + 10); //体力の設定
     sawase[i] = new Human(k1,k2,k3,k4);
  }
  
  //空間の状態管理配列を初期化
  for(int i=0; i< Length; i++){
    for(int j=0; j< Length; j++){
      MAP[i][j] = 0;
    }
  }

}



//メインループ
void draw() {
 
 //背景を描画
 makeground();

 //佐藤軍の行動
 //兵士1人ずつ行動する
 for(int j=0; j < Max_sato; j++){
   
   //生きている状態の兵士だけ行動
   //死んでいる状態の場合は無視
   if(sato[j].type == 1){
     sato[j].draw();
     sato[j].drive();
     sato[j].coll();
     
     //澤勢軍の兵士が近くにいるかどうかを探索
     for(int k=0; k < Max_sawase; k++){
       //生きている澤勢軍の兵士のみを探索
       if(sawase[k].type!=0){
          //縦横20画素以内にいる兵士を攻撃
         if(abs(sato[j].xpos - sawase[k].xpos) < 20){
           if(abs(sato[j].ypos - sawase[k].ypos) < 20){
             
             //攻撃を加えたとき、それっぽくアニメーションをつける
             fill(120,255,255,70);
             ellipse(sato[j].xpos, sato[j].ypos, 60, 60);
           
             //ダメージはランダムで与える
             sawase[k].HP = sawase[k].HP - int(random(3)+1);
             
             //澤勢軍の当該兵士の体力が0未満になったら、その兵士の状態を死の状態へ
             //空間配列から存在を消す
             if(sawase[k].HP < 0){
               sawase[k].type = 0;
               MAP[sawase[k].xpos][sawase[k].ypos] =0;
             }
           }
         }
       }
     }
   }
     
     
  }
  
 //澤勢軍の行動
 //上記の佐藤軍と全く同じ
 for(int j=0; j < Max_sawase; j++){
   
    if(sawase[j].type == 2){
   
     sawase[j].draw();
     sawase[j].drive();
     sawase[j].coll();
     
     for(int k=0; k < Max_sato; k++){
       if(sato[k].type != 0){
         if(abs( sawase[j].xpos - sato[k].xpos) < 20){
           if(abs(sawase[j].ypos - sato[k].ypos) < 20){
             fill(10,255,255,70);
             ellipse(sawase[j].xpos, sawase[j].ypos, 60, 60);
           
             sato[k].HP = sato[k].HP - int(random(3)+1);
             if(sato[k].HP < 0){
               sato[k].type = 0;
               MAP[sato[k].xpos][sato[k].ypos] =0;
             }
           }
         }
       }
     }
    }    
  }
 
 int sato_live = 0;
 for(int j=0; j < Max_sato; j++){
   if(sato[j].type != 0){
     sato_live = sato_live + 1;
   }
 }
 
 int sawase_live = 0;
 for(int j=0; j < Max_sawase; j++){
   if(sawase[j].type != 0){
     sawase_live = sawase_live + 1;
   }
 }
 
  fill(255, 255, 255);
  text("Sato= " + sato_live,0, 50);
  text("Sawase=" + sawase_live , 0,75);

  
}



//人間のクラスを定義
class Human
{

  int xpos; //x座標
  int ypos; //y座標
  int type; //人間の状態
  int HP; //人間の体力の設定
  
  Human(int c, int xp, int yp, int hp) {
    xpos = xp;
    ypos = yp;
    type = c;
    HP = hp;
  }



 //人間を描画する部分
  void draw () {
    
    if(type == 1){
      //頭部を描画しちゃいましょう
      smooth();
      noStroke();
      fill(120,255,255);
      ellipse(xpos,ypos,3,3);
      //胴体を描画しちゃいましょう
      triangle(xpos,ypos,xpos-2,ypos+5,xpos+2,ypos+5);
    }
    
     if(type == 2){
      //頭部を描画しちゃいましょう
      smooth();
      noStroke();
      fill(10,255,255);
      ellipse(xpos,ypos,3,3);
      //胴体を描画しちゃいましょう
      triangle(xpos,ypos,xpos-2,ypos+5,xpos+2,ypos+5);
    }
    
  }


//人間を動かす部分
  void drive () {
    
    //自分の現在の位置を空にする
    MAP[xpos][ypos] = 0;

    //画面の中心にゆくようにしましょう
    if(xpos < (width/2)){
      xpos = (xpos + int((random(3)-1)) + width) % width;
    }
    else{
      xpos = (xpos - int((random(3)-1)) + width) % width;
    }
    
    if(ypos < (height/2)){
      ypos = (ypos + int((random(5))-2) + height) % height;
    }
     else{
       ypos = (ypos - int((random(5))-2) + height) % height;
     }
     
   //自分の移動先に存在を代入
     MAP[xpos][ypos] = type;  
    
  }
  
  
  //衝突の判定
  void coll() {
    
    //自分の周囲 5x5の範囲を探索して、他人がいたら避けるようにする
    for(int i = -5; i < 5; i++){
      for(int j = -5; j < 5; j++){
        if (MAP[(xpos+i+width) % width][(ypos+j+height) % height] != 0){
          
          
          MAP[xpos][ypos] = 0;
          
          //相手から2画素分逃げるようにする
          if(i < 0){
            xpos = (xpos + 2 + width) % width; 
            
          }
          if(i > 0){
            xpos = (xpos - 2 + width) % width;
          }
          
          //相手から2画素分逃げるようにする
          if(j < 0){
            ypos = (ypos + 2 + height) % height;
          }
          if(j > 0){
            ypos = (ypos - 2 + height) % height;
          }
          
          MAP[xpos][ypos] = type; 
          
          if((i!=0)&&(j!=0)){
            if(type == 1){
              fill(120,255,255,50);
            }
            if(type == 2){
              fill(10,255,255,70);
            }
            ellipse(xpos,ypos, 20, 20);
          }
          
        }
      }
    }
  }
  
}

//背景を描画
void makeground(){
  fill(0,0,0); //ちょっと薄めのグリーン
  rect(0,0,width,height);  
}

 void mousePressed() {
 saveFrame("sample_1.png"); 
}








