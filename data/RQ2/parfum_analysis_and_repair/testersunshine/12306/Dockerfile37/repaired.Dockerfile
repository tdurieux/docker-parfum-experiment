FROM python:3.7-slim-buster

ARG CDV=77.0.3865.40

RUN sed -i 's/deb.debian.org/ftp.cn.debian.org/g' /etc/apt/sources.list

RUN apt-get -y update && apt-get install --no-install-recommends -y \
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libcups2 \
    libdbus-1-3 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxss1 \
    libxtst6 \
    lsb-release \
    unzip \
    wget \
    xdg-utils \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV TZ Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /usr/src/app

RUN wget -q https://dl.lancdn.com/landian/soft/chrome/m/77.0.3865.120_amd64.deb && \
    dpkg -i 77.0.3865.120_amd64.deb && rm -f 77.0.3865.120_amd64.deb

RUN wget -q  https://npm.taobao.org/mirrors/chromedriver/$CDV/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip && rm -f chromedriver_linux64.zip

## install python requirements
COPY requirements-docker37.txt ./
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple --no-cache-dir -r requirements-docker37.txt

COPY . .

CMD [ "sh", "-c", "python run.py c && python run.py r" ]
