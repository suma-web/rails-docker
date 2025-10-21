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


