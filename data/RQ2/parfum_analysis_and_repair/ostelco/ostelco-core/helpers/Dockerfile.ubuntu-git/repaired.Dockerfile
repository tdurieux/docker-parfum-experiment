FROM ubuntu
RUN apt-get -q update && apt-get install --no-install-recommends -qqy git && rm -rf /var/lib/apt/lists/*;
