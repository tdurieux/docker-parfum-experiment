FROM ubuntu:latest
COPY . .
RUN apt-get update \
    && apt-get --no-install-recommends -y install \
    siege && rm -rf /var/lib/apt/lists/*;
RUN chmod +x run.sh
CMD [ "sh","run.sh" ]