FROM python:3.7-slim
MAINTAINER Igor Iliunin <ilunin.igor@gmail.com>

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

WORKDIR /usr/src/app

ENV \
  TRADE_DIR=/usr/src/trades \
  TRADE_COMPLETED_DIR=/usr/src/complete_trades \
  CONF_DIR=/usr/src/configs \
  LOGS_DIR=/usr/src/logs

RUN mkdir -p /usr/src/logs && rm -rf /usr/src/logs

COPY requirements.txt /usr/src/app/

RUN \
  apt-get update && \
  apt-get install -y && \
  apt-get install --no-install-recommends -y tzdata && \
  pip install --no-cache-dir --upgrade pip && \
  pip install --no-cache-dir -r requirements.txt && rm -rf /var/lib/apt/lists/*;

VOLUME ["/usr/src/trades", "/usr/src/complete_trades", "/usr/src/configs"]

COPY ./API /usr/src/app/API
COPY ./Bot /usr/src/app/Bot
COPY ./Cloud /usr/src/app/Cloud
COPY ./Utils /usr/src/app/Utils
COPY ./*.py /usr/src/app/

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE 3000
CMD ["python3", "main.py", "api"]
