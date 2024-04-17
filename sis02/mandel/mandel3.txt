// セットアップ部
void setup(){
  size(400,400); //400x400画素の描画窓を作成
  colorMode(HSB); //HSB色空間にセット
  background(0); //背景は黒にセット
}

//描画部
void draw(){
  float a = -0.5; //座標x方向の定数項a 
  float b = 0.0; //座標x方向の定数項b 
  float w = 1.8; //倍率の設定
  
  int h = width / 2; 
  int n = 50; //反復回数をセット
  int c; //カラー変数をセット
  
  int i,j,l;
  float x, y, zx, zy, u, v, mx;
  
  // 各座標点について計算してゆく
  for(i=-h; i<=h; i++){
      u = (w * i / h) + a; // x座標を動かす
      for(j=-h; j<=h; j++){
        v = (w * j / h) + b; // y座標を動かす
        
        x = 0.0;
        y = 0.0;
        for(l=1; l<=n; l++){
          zx = x * x - y * y + u;
          zy = 2 * x * y + v;
          x = zx;
          y = zy;
          mx = x * x + y * y;
          if (mx >= 10.0){
            break; // mxが10以上になったら発散と判定
          }
        }
        
        //発散のスピードが速ければ カラー変数 cの値は小さくなる
        c = int (256 * l / n); 
        
        stroke(c, 256, 256);
        point(200+i, 200-j);
      }
  }
}

