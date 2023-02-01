FROM python:latest

ENV VIRTUAL_ENV "/venv"
RUN python -m venv $VIRTUAL_ENV
ENV PATH "$VIRTUAL_ENV/bin:$PATH"

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y ffmpeg opus-tools bpm-tools
RUN python -m pip install --upgrade pip
RUN python -m pip install wheel
RUN python -m pip install pytgcalls[pyrogram] TgCrypto ffmpeg-python psutil

RUN wget -q https://github.com/LushaiMusic/VC-UserBot/archive/dev.tar.gz && \
    tar xf dev.tar.gz && rm dev.tar.gz

WORKDIR /VC-UserBot-master
CMD python3 main.py

# docker build -t tgcalls .
# docker run -it --rm --env-file ./envfile --name VC-UserBot tgcalls
