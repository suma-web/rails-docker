# README
### 環境構築方法（Mac環境でdocker-composeで既存のrailsアプリをDocker化）
1\. Macのターミナル（Terminal）を起動。

2\. GitHub内で作成したrailsアプリを`git clone <リポジトリのURL>`コマンドで、ローカル環境へ。（ディレクトリは任意の場所で問題なし）
  - 今回はDesktop内に`clone`したリポジトリをおいて説明します。

3\. 【下準備】Docker化するのにRailsとpostgreSQL２つのコンテナを立てる。
- ディレクトリ dockerの作成：`mkdir docker`
- `cd docker`でディレクトリ内に移動
- docker内にDockerfileの作成：`touch Dockerfile`（以下のコードを入力 `vi/vim Dockerfile`で編集）

```
# ベースイメージの指定
FROM ruby:3.2.2

# パッケージのインストールと更新
RUN apt-get update -qq && apt-get install -y --no-install-recommends nodejs postgresql-client build-essential libpq-dev && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリの指定
WORKDIR /myapp

# fileの追加
COPY Gemfile Gemfile.lock ./

# gemをインストールする際のコマンド
RUN bundle install　　　

COPY . /myapp
```


- docker-compose.ymlの作成： `touch docker-compose.yml`（以下のコードを入力 `vi/vim docker-compose.yml`で編集）
```
# バージョンを指定
version: '3'

services:
# dbコンテナの設置
  db:
    container_name: rails-docker-db
    image: postgres:12
    environment:
      POSTGRES_PASSWORD: postgres
      POSTGRES_USER: postgres
    volumes:
      - type: volume
        source: rails-docker-db-volume
        target: /var/lib/postgresql/data
# webコンテナの設置
  web:
    build:
      context: .
    command: bundle exec rails s -p 3000 -b '0.0.0.0'
    environment:
      POSTGRES_PASSWORD: postgres
      POSTGRES_USER: postgres
    volumes:
      - type: bind
        source: .
        target: /myapp
    ports:
      - '3000:3000'     
    depends_on:
      - db

volumes: 
  rails-docker-db-volume:

```

- gemfileを作成：`touch gemfile`（以下のコードを入力 `vi/vim gemfile`で編集）
```
ruby "3.2.2"gem 
"rails", "~> 7.0.6"
```

4\.Docker化するのにRailsとpostgreSQL２つのコンテナを立てる。`docker-compose build`でイメージの作成。

5\. `docker-compose up -d`でコンテナの作成と起動。

6\. `docker-compose exec web bash`でコンテナの中に入る。

7\. `rails db:create`でデータベースを作成。

8\. `rails db:migrate`でデータベースの更新。

9\. 最終確認
ブラウザ上で`http://localhost:3000`にアクセス。ブラウザ上でアプリケーションが確認できれば完成です。

これでrailsアプリをDocker化する手順は以上です。お疲れ様でした。

# よくあるエラー
Dockerfile や docker-compose.yml にて、Rubyやrailsのバージョン同士に適正があるので、組み合わせとして相応のものを記述してください。
詳しくは下のサイトにあります。

https://www.fastruby.io/blog/ruby/rails/versions/compatibility-table.html

