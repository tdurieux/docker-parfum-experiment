FROM python:3.7-slim

WORKDIR /app

ADD . /app

RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["/app/entrypoint.sh"]