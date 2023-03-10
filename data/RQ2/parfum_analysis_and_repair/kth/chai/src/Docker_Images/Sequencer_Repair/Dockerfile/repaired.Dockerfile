FROM openjdk:8u252-jdk-slim
COPY --from=python:3.6-slim / /

WORKDIR /root/sequencer

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/OpenNMT/OpenNMT-py.git tools/OpenNMT-py
RUN cd tools/OpenNMT-py && python3 setup.py install
RUN pip3 install --no-cache-dir javalang

COPY ./docker-sequencer-predict.sh sequencer-predict.sh
COPY ./tools tools/
COPY ./models models/
