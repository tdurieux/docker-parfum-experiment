FROM debian:jessie

RUN apt-get update && apt-get -y --no-install-recommends install gforth && rm -rf /var/lib/apt/lists/*;

ADD runforth.sh runforth.sh
ENTRYPOINT ["bash", "runforth.sh"]
