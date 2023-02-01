FROM ubuntu:20.04
WORKDIR /usr/challenge
COPY ./challenge .
COPY ./where_is_the_flag.txt .
COPY ./flag.txt .
COPY ./scoreboard.txt .
RUN chmod a+rx ./challenge
RUN chmod a+r ./where_is_the_flag.txt ./flag.txt
RUN chmod a+rw ./scoreboard.txt
RUN apt update && apt -y --no-install-recommends install socat && rm -rf /var/lib/apt/lists/*;
EXPOSE 1
CMD while true; do socat tcp-l:1,reuseaddr,fork 'exec:/usr/challenge/challenge .'; done
