FROM ubuntu:latest

WORKDIR /workdir

# apt を最新にして sudo, curl コマンドをインストール
RUN apt-get -y update && apt-get install --no-install-recommends -y sudo curl && rm -rf /var/lib/apt/lists/*;

# Java の環境のインストール
RUN apt-get install --no-install-recommends -y openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;

# Firebase CLI のインストール
RUN curl -f -sL "https://firebase.tools" | bash

# Node.js と npm のインストール
RUN apt install --no-install-recommends -y nodejs npm && rm -rf /var/lib/apt/lists/*;

# エミュレータの設定
ENV HOST 0.0.0.0
EXPOSE 4000
EXPOSE 5001
EXPOSE 8080

# Firebase ログインに必要なポート
EXPOSE 9005