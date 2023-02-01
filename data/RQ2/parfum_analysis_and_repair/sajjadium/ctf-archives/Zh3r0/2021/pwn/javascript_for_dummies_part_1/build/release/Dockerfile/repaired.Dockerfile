FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends -y libreadline-dev python3 libjemalloc2 && rm -rf /var/lib/apt/lists/*;

RUN useradd -d /home/challenge/ -m -p challenge -s /bin/bash challenge
RUN echo "challenge:challenge" | chpasswd

WORKDIR /home/challenge
COPY ./libjemalloc.so.2 .
COPY ./mujs .
COPY ./run.sh .
COPY ./ynetd .
COPY ./start.sh .
COPY ./connect.py .
RUN echo "zh3r0{test_flag}" > flag
RUN chown -R root:root /home/challenge

USER challenge
EXPOSE 1337
CMD ./start.sh
