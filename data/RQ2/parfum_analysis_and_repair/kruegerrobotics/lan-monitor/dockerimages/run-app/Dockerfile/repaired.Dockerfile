FROM debian:latest

RUN apt-get update
RUN apt-get install --no-install-recommends wget -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends nmap -y && rm -rf /var/lib/apt/lists/*;

COPY download_and_run.sh .

EXPOSE 8080

CMD sh ./download_and_run.sh
