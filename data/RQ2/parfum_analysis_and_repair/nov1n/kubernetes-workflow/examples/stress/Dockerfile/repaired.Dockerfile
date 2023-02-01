FROM jess/stress

RUN apt-get update && apt-get install --no-install-recommends -y cpulimit && rm -rf /var/lib/apt/lists/*;
