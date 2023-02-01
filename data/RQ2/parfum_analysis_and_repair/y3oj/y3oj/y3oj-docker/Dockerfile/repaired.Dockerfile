FROM nikolaik/python-nodejs:python3.9-nodejs12

RUN groupadd --gid 1001 y3oj && useradd --uid 1001 --gid y3oj --shell /bin/bash --create-home y3oj

WORKDIR /home/y3oj

COPY requirements.txt .
RUN pip install --no-cache-dir numpy flask pandas --index-url https://pypi.douban.com/simple
RUN pip install --no-cache-dir -r requirements.txt --index-url https://pypi.douban.com/simple

RUN npm install -g less ts-node typescript --registry=https://registry.npm.taobao.org && npm cache clean --force;

USER y3oj
WORKDIR /opt/y3oj

RUN echo 'Hello, World! This is y3oj-docker.'
