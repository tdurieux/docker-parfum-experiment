# docker build -t classificationbot/bot-standalone:latest -f dockerfiles/bot-standalone/Dockerfile .
# docker push classificationbot/bot-standalone:latest
FROM classificationbot/deploy-base:latest

COPY ./requirements-bot.txt /tmp/
RUN pip install --no-cache-dir -r /tmp/requirements-bot.txt

RUN pip install --no-cache-dir supervisor
COPY etc/supervisord.conf /etc/supervisord.conf
COPY etc/supervisord /etc/supervisord

ENTRYPOINT ["/usr/local/bin/supervisord"]
