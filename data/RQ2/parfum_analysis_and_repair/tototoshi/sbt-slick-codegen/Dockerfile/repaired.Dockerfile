FROM debian:buster-slim

RUN apt-get update
RUN apt-get -y --no-install-recommends install locales-all && rm -rf /var/lib/apt/lists/*;

ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential \
                       openjdk-11-jdk \
                       curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y postgresql && rm -rf /var/lib/apt/lists/*;

CMD "/bin/bash"
