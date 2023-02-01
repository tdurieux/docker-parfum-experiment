FROM debian:9
RUN apt-get update && apt-get -y --no-install-recommends install vim && apt-get clean && rm -rf /var/lib/apt/lists/*;
USER foo
