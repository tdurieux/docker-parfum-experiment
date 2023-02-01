FROM alphacep/kaldi-vosk-server:latest

ENV MODEL_VERSION 0.22
RUN mkdir /opt/vosk-model-es \
   && cd /opt/vosk-model-es \
   && wget -q https://alphacephei.com/vosk/models/vosk-model-small-es-${MODEL_VERSION}.zip \
   && unzip vosk-model-small-es-${MODEL_VERSION}.zip \
   && mv vosk-model-small-es-${MODEL_VERSION} model \
   && rm -rf vosk-model-small-es-${MODEL_VERSION}.zip

EXPOSE 2700
WORKDIR /opt/vosk-server/websocket
CMD [ "python3", "./asr_server.py", "/opt/vosk-model-es/model" ]