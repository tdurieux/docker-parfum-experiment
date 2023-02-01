FROM debian:buster
RUN apt-get update && apt-get install --no-install-recommends -y devscripts vim gnupg2 sudo && rm -rf /var/lib/apt/lists/*;
