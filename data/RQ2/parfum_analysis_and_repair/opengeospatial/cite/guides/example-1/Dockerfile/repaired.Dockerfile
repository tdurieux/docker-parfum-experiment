FROM adoptopenjdk/openjdk8

ADD . /app/

RUN apt-get update && apt-get install --no-install-recommends -y git && apt-get install --no-install-recommends -y wget && apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;

CMD ["sh","/app/ets_setup.sh"]
