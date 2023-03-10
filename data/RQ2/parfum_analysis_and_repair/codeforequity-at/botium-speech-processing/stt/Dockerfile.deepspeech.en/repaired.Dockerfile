FROM python:3.5

RUN wget https://github.com/mozilla/DeepSpeech/releases/download/v0.5.1/deepspeech-0.5.1-models.tar.gz && \
  tar xvzf deepspeech-0.5.1-models.tar.gz && mv deepspeech-0.5.1-models models && \
  rm deepspeech-0.5.1-models.tar.gz

COPY ./models/config_en.json /models/config.json
ENV config /models/config.json

RUN pip3 install --no-cache-dir "deepspeech==0.5.1"
RUN pip3 install --no-cache-dir "deepspeech-server==1.1.0"
RUN pip3 uninstall -y cyclotron && pip3 install --no-cache-dir "cyclotron==0.6.1"
RUN pip3 uninstall -y cyclotron-aio && pip3 install --no-cache-dir "cyclotron-aio==0.7.0"
RUN pip3 uninstall -y cyclotron-std && pip3 install --no-cache-dir "cyclotron-std==0.5.0"
RUN pip3 uninstall -y Rx && pip3 install --no-cache-dir "Rx==1.6.1"

CMD ["sh", "-c", "/usr/local/bin/deepspeech-server --config ${config}"]