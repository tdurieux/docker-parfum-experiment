FROM ubuntu:16.04

# 基本的な設定
RUN apt update -y && apt install --no-install-recommends -y wget tzdata python3 sqlite3 && rm -rf /var/lib/apt/lists/*;
RUN wget -O- https://bootstrap.pypa.io/get-pip.py | python3
RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# アプリの実行環境設定
COPY ./src/constraints.txt /tmp
COPY ./src/requirements.txt /tmp
RUN pip install --no-cache-dir -r /tmp/requirements.txt

RUN ln -s /usr/bin/python3 /usr/bin/python
