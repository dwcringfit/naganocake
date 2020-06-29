# NaganoCAKE
　このサイトはプログラミング教室、DMM WEBCAMPのカリキュラムでチーム開発のフェーズとして作成した架空のお菓子販売ECサイトです。

# 実装機能
- 顧客側閲覧画面（Client）
  - 会員登録・編集・退会
  - 商品の表示・カートへの追加
  - 配送先の追加
  - 注文履歴の確認

- 店舗側管理者画面（Admin）
  - 注文履歴の確認・入金確認から製作ステータスの変更
  - 会員情報の確認・編集
  - 商品の登録・編集・削除
  - ジャンル登録・編集
  - 顧客・商品検索

  - Rspec（テスト要件に合わせ102項目すべての内容を実装）

# 開発環境
- Ruby 2.5.7
- Rails 5.2.4.1
- SQlite3 3.31.1
- HTML5
- CSS3

# 導入方法
$ git clone git@github.com:dwcringfit/naganocake.git
$ cd naganocake
$ rails db:seed
$ rails s -b 0.0.0.0

# 開発メンバー
https://github.com/Libra4101
 - Rspec・ログイン機能・チーム全体統括
https://github.com/yuto14
 - カートへの商品追加・検索機能
https://github.com/fyewsha000
 - 商品の登録・編集機能、サイトデザイン、ロゴ作成
https://github.com/kounaien
 - 配送先の追加、注文履歴機能
https://github.com/Shimizu-Mitsuharu
 - 注文機能、顧客編集・退会機能