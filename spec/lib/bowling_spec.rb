

#ボウリングクラスの読み込み
#puts $LOAD_PATH
$LOAD_PATH.unshift "/home/imura/work"
require "bowling"

describe "ボウリングのスコア計算" do

 #インスタンスの生成を共通化(:eachは各it毎に実行される、:allははじめの1回のみ)
before(:each) do
    @game =Bowling.new
end


   describe "全体の合計" do


      context "すべての投球で1ピンずつ倒した場合" do
  	     it "20になること" do
            add_many_scores(20, 1)
            #合計を計算
            @game.calc_score
  	      expect(@game.total_score).to eq 20
  	     end
       end

     context "すべての投球がガターだった場合" do
	     it "0になること" do
          add_many_scores(20, 0)
          #合計を計算
          @game.calc_score
          expect(@game.total_score).to eq 0
	     end
     end


    context "スペアを取った場合" do
	     it "スペアボーナスが加算されること" do
             #第一フレームで3点、7点のスペア
             @game.add_score(3)
             @game.add_score(7)
             #第二フレームの一投目で4点
             @game.add_score(4)
             #以降はすべてガター
             add_many_scores(17, 0)
             #合計を計算
             @game.calc_score
             #期待する合計　※()内はボーナス点
             #3+7+4+(4)= 18
             expect(@game.total_score).to eq 18
         end
      end
    context "フレーム違いでスペアになるようなスコアだった場合" do
	     it "スペアボーナスが加算されないこと" do
               #第一フレームで3点、5点
               @game.add_score(3)
               @game.add_score(5)
               #第二フレームで5点、４点
               @game.add_score(5)
               @game.add_score(4)
               #以降はすべてガター
               add_many_scores(16,0)
               #合計を計算
               @game.calc_score
               #期待する合計　
               #3+５+５+４ = 17
               expect(@game.total_score).to eq 17
           end
      end
    context "最終フレームでスペアを取った場合" do
        it "スペアボーナスが加算されないこと" do
           #第一フレームで3点、7点のスペア
           @game.add_score(3)
           @game.add_score(7)
           #第二レームの一投目で4点
           @game.add_score(4)
           #15投はすべてガター
           add_many_scores(15,0)
           #最終フレームで3点、7点のスペア
           @game.add_score(3)
           @game.add_score(7)
           #合計を計算
           @game.calc_score
           #期待する合計　※()内はボーナス点
           #3+7+4+(4)+3+7 = 28
           expect(@game.total_score).to eq 28
        end
      end

      context "ストライクを取った場合" do
          it "ストライクボーナスが加算されること" do
             #第一フレームでストライク
             @game.add_score(10)
             #第二レームので5点、4点
             @game.add_score(5)
             @game.add_score(4)
             #以降はすべてガター
             add_many_scores(16,0)
             #合計を計算
             @game.calc_score
             #期待する合計　※()内はボーナス点
             #１０+５+（５）+4+(4)=28
             expect(@game.total_score).to eq 28
          end
        end

        context "ダブルを取った場合" do
            it "それぞれのストライクボーナスが加算されること" do
               #第一フレームでストライク
               @game.add_score(10)
               #第二フレームでストライク
               @game.add_score(10)
               #第三レームので5点、4点
               @game.add_score(5)
               @game.add_score(4)
               #以降はすべてガター
               add_many_scores(14,0)
               #合計を計算
               @game.calc_score
               #期待する合計　※()内はボーナス点
               #１０+１０＋（１０）＋５+（５＋５）+4＋（４）=53
               expect(@game.total_score).to eq 53
            end
          end

          context "ターキーを取った場合" do
              it "それぞれのストライクボーナスが加算されること" do
                 #第一フレームでストライク
                 @game.add_score(10)
                 #第二フレームでストライク
                 @game.add_score(10)
                 #第三フレームでストライク
                 @game.add_score(10)
                 #第四レームので5点、4点
                 @game.add_score(5)
                 @game.add_score(4)
                 #以降はすべてガター
                 add_many_scores(12,0)
                 #合計を計算
                 @game.calc_score
                 #期待する合計　※()内はボーナス点
                 #１０+１０＋（１０）＋10+（10＋10）+5＋（5＋５）+4＋（４）=83
                 expect(@game.total_score).to eq 83
              end
            end

            context "最終フレームでストライクを取った場合" do
                it "ストライクボーナスが加算されないこと" do
                   #第一フレームでストライク
                   @game.add_score(10)
                   #第二レームので5点、4点
                   @game.add_score(5)
                   @game.add_score(4)
                   #3〜9フレームはすべてガター
                   add_many_scores(14,0)
                   #最終フレームでストライク
                   @game.add_score(10)
                   #合計を計算
                   @game.calc_score
                   #期待する合計　※()内はボーナス点
                   #１０+5＋（5）+4＋（４）＋１０=38
                   expect(@game.total_score).to eq 38
                end
              end
end
end

private
#複数回のスコア追加をまとめて実行する
def add_many_scores(count, pins)
  count.times do
    @game.add_score(pins)
  end
end
