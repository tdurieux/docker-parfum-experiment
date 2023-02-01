FROM confluentinc/cp-kafkacat

RUN apt-get update && apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;

RUN curl -f -O https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh

RUN chmod 755 wait-for-it.sh

COPY . .

CMD ["sh", "feed.sh"]