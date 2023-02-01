FROM node:latest

RUN apt-get update && apt-get install --no-install-recommends -y libnss3-dev libgtk-3-dev libxss-dev libasound2 && rm -rf /var/lib/apt/lists/*;
RUN groupadd -r bot && useradd bot -g bot && mkdir /home/bot && chown -R bot:bot /home/bot

USER bot

ENTRYPOINT /bot/entrypoint.sh