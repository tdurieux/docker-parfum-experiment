FROM claf/claf:latest
RUN git clone https://github.com/DongjunLee/kino-bot.git && cd kino-bot && pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir wrapt --upgrade --ignore-installed && pip install --no-cache-dir tensorflow==1.14.0

RUN mkdir -p config
RUN mkdir -p data/record

COPY data/cache.json /workspace/kino-bot/data/cache.json
COPY data/cache_feed.json /workspace/kino-bot/data/cache_feed.json
COPY config/config.yml /workspace/kino-bot/config/config.yml

WORKDIR kino-bot
CMD [ "python", "main.py" ]
