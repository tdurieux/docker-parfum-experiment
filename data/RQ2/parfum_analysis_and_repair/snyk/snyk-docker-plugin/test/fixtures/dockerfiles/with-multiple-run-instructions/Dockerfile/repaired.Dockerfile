FROM ubuntu:bionic

RUN apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends wget && rm -rf /var/lib/apt/lists/*;

CMD ["bash"]