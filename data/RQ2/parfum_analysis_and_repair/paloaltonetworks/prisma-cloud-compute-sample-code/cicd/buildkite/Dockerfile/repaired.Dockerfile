FROM ubuntu:14.04

LABEL owner_email="email@example.com"
LABEL product="sample"
LABEL env="Dev"
LABEL team="Team A"

RUN apt-get update && apt-get -y --no-install-recommends install curl git nmap dnsutils && rm -rf /var/lib/apt/lists/*;
CMD apt-get -y install httpd


