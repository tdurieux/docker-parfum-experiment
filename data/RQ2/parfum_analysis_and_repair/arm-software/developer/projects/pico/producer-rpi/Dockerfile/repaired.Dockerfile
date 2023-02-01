FROM fradelg/rpi-opencv

MAINTAINER ajeetraina@gmail.com

RUN apt-get update
RUN apt install -y --no-install-recommends python-pip python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir pytz kafka-python
RUN pip install --no-cache-dir virtualenv virtualenvwrapper
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/collabnix/pico
WORKDIR pico/deployment/objects
