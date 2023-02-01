FROM python:3.10-slim
LABEL maintainer=Asgoret

ARG APP_USER=bot
ARG APP_GROUP=botgroup

ENV APP_USER=${APP_USER}
ENV APP_GROUP=${APP_GROUP}

RUN addgroup --system ${APP_GROUP} && adduser --system --ingroup ${APP_GROUP} ${APP_USER}

USER ${APP_USER}
WORKDIR /home/${APP_USER}

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY ./bot /bot
WORKDIR /bot

ENV APP_TELEGRAM_BOT_TOKEN=changeme
ENV APP_CONFIG_PATH=./config.yml

CMD ["python", "devopshelberbot.py"]
