FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends socat -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get dist-upgrade -y


RUN useradd -m vuln
COPY vuln flag.txt /home/vuln/
RUN chown -R root:vuln /home/vuln/
RUN chmod -R 750 /home/vuln/
EXPOSE 4444
USER vuln
CMD socat -T10 TCP-LISTEN:4444,reuseaddr,fork EXEC:/home/vuln/vuln