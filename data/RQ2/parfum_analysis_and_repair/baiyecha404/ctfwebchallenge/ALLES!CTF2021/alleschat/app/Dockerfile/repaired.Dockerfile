FROM node:slim

ENV DEBIAN_FRONTEND noninteractive
ENV TZ Europe/Berlin

ENV DISPLAY :99
ENV XDG_CURRENT_DESKTOP XFCE
ENV BOT 1

RUN apt update && \
    apt install --no-install-recommends -y curl && \
    apt install -y --no-install-recommends xvfb && \
    apt install -y --no-install-recommends xauth && \
    apt install --no-install-recommends -y libnss3-dev && \
    apt install --no-install-recommends -y libgbm-dev && \
    apt install --no-install-recommends -y libasound2-dev && \
    apt install -y --no-install-recommends xfce4 && \
    apt install -y --no-install-recommends xdg-utils && rm -rf /var/lib/apt/lists/*;

COPY package.json /app/
COPY ./src/ /app/src/

WORKDIR /app
RUN npm install && npm cache clean --force;

RUN chown -R node:node /app/

COPY run.sh readflag flag.txt /app/
RUN chmod +xs readflag && \
    chmod 600 flag.txt

USER node

CMD [ "bash", "./run.sh" ]
