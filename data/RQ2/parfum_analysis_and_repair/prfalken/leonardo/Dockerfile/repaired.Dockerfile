FROM ubuntu:14.04

RUN apt-get update && apt-get install --no-install-recommends -y python3-pip git build-essential && rm -rf /var/lib/apt/lists/*;

WORKDIR /leonardo

ADD requirements.txt /leonardo/
RUN pip install --no-cache-dir -r requirements.txt

ADD . /leonardo/

RUN mv config/leonardo.yaml.example config/leonardo.yaml
COPY sample/graphs/ /leonardo/graphs/

EXPOSE 5000

CMD ./run.py
