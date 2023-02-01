FROM ubuntu
RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
ADD flekszible /usr/bin/flekszible

