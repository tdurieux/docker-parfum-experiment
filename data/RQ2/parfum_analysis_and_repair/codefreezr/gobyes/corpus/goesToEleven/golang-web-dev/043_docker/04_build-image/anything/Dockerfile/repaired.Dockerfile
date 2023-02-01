# Changes whalesay to speak a fortune
FROM docker/whalesay:latest
RUN apt-get -y update && apt-get install --no-install-recommends -y fortunes && rm -rf /var/lib/apt/lists/*;
CMD /usr/games/fortune -a | cowsay