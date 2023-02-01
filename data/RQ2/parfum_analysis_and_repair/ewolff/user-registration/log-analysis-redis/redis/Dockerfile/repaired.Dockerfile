FROM ubuntu:14.04
RUN apt-get update -qq && apt-get install --no-install-recommends -y -qq redis-server && rm -rf /var/lib/apt/lists/*;
CMD redis-server
EXPOSE 6379