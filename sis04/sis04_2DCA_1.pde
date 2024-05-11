/**
 * サンプルプログラム
 * 2次元セルオートマトンの基本プログラム
 */


int sx, sy; //2次元セルを管理する縦と横の長さ
float density = 0.5; //初期状態の密度
int[][][] world; //各セルを管理する配列

//初期化部
void setup()
{
  size(200, 200); //描画窓は200x200
  frameRate(30); //フレームレートは12
  sx = width; //2次元セルの管理配列の横の長さ
  sy = height; //2次元セルの管理配列の縦の長さ

   //sx * sy の大きさの配列を2つ準備
   //ここで、1つめは現在の世代、2つめは次の世代を保管するために使う
  world = new int[sx][sy][2];

  stroke(255);   //点の色は白

  //初期化 sx * sy * densityの分だけ、生きているセルにセット
  for (int i = 0; i < sx * sy * density; i++) {
    world[(int)random(sx)][(int)random(sy)][1] = 1;
  }

}

 //メインループ
void draw()
{
  background(0); //背景を黒にセット

  //描画ループ
  //world[x][y][1]の状態を初期化しながら
  //world[x][y][0]にworld[x][y][1]の状態をコピー
  //但し、world[x][y][1]は特に更新されない場合もあるので
  //その場合を区別するために、1,0,-1の3つの状態使う
  for (int x = 0; x < sx; x=x+1) {
    for (int y = 0; y < sy; y=y+1) {

      if ((world[x][y][1] == 1) || (world[x][y][1] == 0 && world[x][y][0] == 1))
      {
        world[x][y][0] = 1;
        point(x, y);
      }
      if (world[x][y][1] == -1)
      {
        world[x][y][0] = 0;
      }
      world[x][y][1] = 0;
    }
  }

  // 各セルの生死判定
  for (int x = 0; x < sx; x=x+1) {
    for (int y = 0; y < sy; y=y+1) {

      //周囲のセルの生死状態をカウントする
      int count = neighbors(x, y);

      //もし自分自身が死んでいて、周囲のセル3つが生きていたら復活する
      if (count == 3 && world[x][y][0] == 0)
      {
        world[x][y][1] = 1;
      }
      //もし自分自身が生きていて、周囲のセルが1個以下、あるいは4個以上の
      //場合は、自分は死ぬ
      if ((count < 2 || count > 3) && world[x][y][0] == 1)
     {
        world[x][y][1] = -1;
      }
    }
  }
}

//周囲のセルの生死を判定する関数
int neighbors(int x, int y)
{
  return world[(x + 1) % sx][y][0] +
         world[x][(y + 1) % sy][0] +
         world[(x + sx - 1) % sx][y][0] +
         world[x][(y + sy - 1) % sy][0] +
         world[(x + 1) % sx][(y + 1) % sy][0] +
         world[(x + sx - 1) % sx][(y + 1) % sy][0] +
         world[(x + sx - 1) % sx][(y + sy - 1) % sy][0] +
         world[(x + 1) % sx][(y + sy - 1) % sy][0];
}