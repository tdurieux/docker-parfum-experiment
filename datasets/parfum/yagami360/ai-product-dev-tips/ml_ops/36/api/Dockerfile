#-----------------------------
# Docker イメージのベースイメージ
#-----------------------------
FROM python:3.8-slim
#FROM tiangolo/uvicorn-gunicorn-fastapi:python3.7

#-----------------------------
# 基本ライブラリのインストール
#-----------------------------
# インストール時のキー入力待ちをなくす環境変数
ENV DEBIAN_FRONTEND noninteractive

RUN set -x && apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    git \
    curl \
    wget \
    bzip2 \
    ca-certificates \
    libx11-6 \
    python3-pip \
    # imageのサイズを小さくするためにキャッシュ削除
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade pip

#-----------------------------
# 環境変数
#-----------------------------
ENV LC_ALL=C.UTF-8
ENV export LANG=C.UTF-8
ENV PYTHONIOENCODING utf-8

#-----------------------------
# 追加ライブラリのインストール
#-----------------------------
RUN pip3 install fastapi
RUN pip3 install uvicorn
RUN pip3 install Gunicorn
RUN pip3 install requests

RUN pip3 install PyMySQL
RUN pip3 install sqlalchemy

RUN pip3 install Pillow

#-----------------------------
# ソースコードの書き込み
#-----------------------------
#COPY *.py /api/
#COPY utils/*.py /api/utils/
#COPY log/*.log /api/log/

#-----------------------------
# ポート開放
#-----------------------------
EXPOSE 5000

#-----------------------------
# コンテナ起動後に自動的に実行するコマンド
#-----------------------------
# docker-compose で起動定義するのでコメントアウト
#CMD ["gunicorn","app:app","--bind","0.0.0.0:5000","-w","1","-k","uvicorn.workers.UvicornWorker","--reload"]

#-----------------------------
# コンテナ起動後の作業ディレクトリ
#-----------------------------
WORKDIR /api
