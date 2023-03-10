FROM ubuntu:19.10

ARG CREDENTIALS
ENV CREDENTIALS $CREDENTIALS

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y mpg123 python3-pyaudio vim python3 python3-pip curl mpg321 \
    alsa-utils alsa-base libasound2-plugins \
    && rm -fr /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --upgrade pip
COPY requirements.amd64.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install --no-cache-dir torch==1.5.0+cpu torchvision==0.6.0+cpu -f https://download.pytorch.org/whl/torch_stable.html
RUN echo 'deb [arch=amd64] https://storage.googleapis.com/tensorflow-serving-apt stable tensorflow-model-server tensorflow-model-server-universal' |  tee /etc/apt/sources.list.d/tensorflow-serving.list
RUN curl -f https://storage.googleapis.com/tensorflow-serving-apt/tensorflow-serving.release.pub.gpg | apt-key add -
RUN apt-get update \
    && apt-get install --no-install-recommends -y tensorflow-model-server && rm -rf /var/lib/apt/lists/*;
RUN echo "@audio - rtprio 99" >> /etc/security/limits.conf
RUN mkdir app
WORKDIR app

ENTRYPOINT $CREDENTIALS