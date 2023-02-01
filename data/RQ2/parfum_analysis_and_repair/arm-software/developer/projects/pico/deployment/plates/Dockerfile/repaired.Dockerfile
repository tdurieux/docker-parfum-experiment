FROM ajeetraina/rpi-raspbian-opencv
MAINTAINER Ajeet S Raina "ajeetraina@gmail.c
RUN apt update -y && apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir pytz
RUN pip3 install --no-cache-dir kafka-python

ADD . /pico/
WORKDIR /pico/
ENTRYPOINT ["python3", "/pico/plates-producer.py" ]
