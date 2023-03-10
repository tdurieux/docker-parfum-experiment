FROM webrecorder/pywb:2.4.1

WORKDIR /build
ADD requirements.txt /build/

USER root

RUN pip install --no-cache-dir git+https://github.com/FedericoCeratto/bottle-cork.git@94d4017a4d1b0d20328e9283e341bd674df3a18a#egg=bottle-cork

RUN pip install --no-cache-dir -r requirements.txt

ENV VOLUME_DIR /data/

VOLUME /data/

# Expose as VOLUMEs for nginx access
VOLUME /usr/local/lib/python3.5/site-packages/pywb/
VOLUME /code/


WORKDIR /code/
