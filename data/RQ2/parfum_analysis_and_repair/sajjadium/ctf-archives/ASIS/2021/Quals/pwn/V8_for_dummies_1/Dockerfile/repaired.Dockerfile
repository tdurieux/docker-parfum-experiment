FROM UBUNTU:20.04

RUN apt-get update && apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;

RUN useradd -d /home/challenge/ -m -p challenge -s /bin/bash challenge
RUN echo "challenge:challenge" | chpasswd

WORKDIR /home/challenge

COPY ./run.sh .
COPY ./ynetd .
COPY ./start.sh .
COPY ./connect.py .
COPY ./d8 .
COPY ./snapshot_blob.bin .
COPY ./flag-4692ae2c9ada5ed9a3f916bd2d46e907.txt

RUN chown -R root:root /home/challenge

USER challenge
CMD ./start.sh
