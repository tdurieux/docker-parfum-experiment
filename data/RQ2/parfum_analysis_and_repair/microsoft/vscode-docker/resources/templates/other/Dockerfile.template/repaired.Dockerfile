FROM docker/whalesay:latest
LABEL Name={{ serviceName }} Version={{ version }}
RUN apt-get -y update && apt-get install --no-install-recommends -y fortunes && rm -rf /var/lib/apt/lists/*;
CMD ["sh", "-c", "/usr/games/fortune -a | cowsay"]
