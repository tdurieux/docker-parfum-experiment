FROM ubuntu
RUN apt-get -y update && apt-get -y --no-install-recommends install figlet && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT ["figlet", "-f", "script"]

