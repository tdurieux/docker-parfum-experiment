FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends python3 -y && rm -rf /var/lib/apt/lists/*;

RUN useradd -d /home/challenge/ -m -p challenge -s /bin/bash challenge
RUN echo "challenge:challenge" | chpasswd

WORKDIR /home/challenge
COPY ./share/_note.cpython-36m-x86_64-linux-gnu.so .
COPY ./share/pppp.py .
COPY ./share/template.py .
COPY ./share/flag .
COPY ./share/ynetd .
COPY ./share/run.sh .
COPY ./share/python3 .
RUN chown -R root:root /home/challenge/

USER challenge
CMD ./run.sh

