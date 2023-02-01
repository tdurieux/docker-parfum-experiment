FROM alphacep/kaldi-vosk-server:latest

ENV MODEL_VERSION 0.21
RUN mkdir /opt/vosk-model-de \
   && cd /opt/vosk-model-de \
   && wget -q https://alphacephei.com/vosk/models/vosk-model-de-${MODEL_VERSION}.zip \
   && unzip vosk-model-de-${MODEL_VERSION}.zip \
   && mv vosk-model-de-${MODEL_VERSION} model \
   && rm vosk-model-de-${MODEL_VERSION}.zip

EXPOSE 2700
WORKDIR /opt/vosk-server/websocket
CMD [ "python3", "./asr_server.py", "/opt/vosk-model-de/model" ]