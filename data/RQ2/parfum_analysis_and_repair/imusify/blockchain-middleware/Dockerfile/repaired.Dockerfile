FROM ubuntu:16.04

RUN apt-get update && apt-get -y --no-install-recommends install git python3-dev python3-pip libleveldb-dev libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/CityOfZion/neo-python.git

WORKDIR neo-python

RUN pip3 install --no-cache-dir -r requirements.txt

CMD python3 prompt.py
