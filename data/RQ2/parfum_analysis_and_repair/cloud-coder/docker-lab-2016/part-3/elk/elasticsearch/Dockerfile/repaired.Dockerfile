FROM elasticsearch:2.4.0
RUN apt-get -y update && apt-get install --no-install-recommends -y curl nano && rm -rf /var/lib/apt/lists/*;
