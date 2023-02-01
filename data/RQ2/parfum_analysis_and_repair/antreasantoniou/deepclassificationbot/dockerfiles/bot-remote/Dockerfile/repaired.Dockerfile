FROM classificationbot/deploy-base:latest

COPY ./requirements-bot.txt /tmp/
RUN pip install --no-cache-dir -r /tmp/requirements-bot.txt

WORKDIR /opt/bot
ENTRYPOINT ["/usr/bin/python", "deepanimebot/bot.py"]
