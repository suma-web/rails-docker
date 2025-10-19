# ベースイメージの指定
FROM ruby:3.2.2

# パッケージのインストールと更新
RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y postgresql-client --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# 作業ディレクトリの指定
WORKDIR /myproject

# fileの追加
ADD Gemfile /myproject/Gemfile
ADD Gemfile.lock /myproject/Gemfile.lock

# gemをインストールする際のコマンド
RUN bundle install　　　

ADD . /myproject


