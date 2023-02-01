FROM alphacep/kaldi-vosk-server:latest

ENV MODEL_VERSION 0.5
RUN mkdir /opt/vosk-model-en-in \
   && cd /opt/vosk-model-en-in \
   && wget -q https://alphacephei.com/vosk/models/vosk-model-en-in-${MODEL_VERSION}.zip \
   && unzip vosk-model-en-in-${MODEL_VERSION}.zip \
   && mv vosk-model-en-in-${MODEL_VERSION} model \
   && rm vosk-model-en-in-${MODEL_VERSION}.zip

EXPOSE 2700
WORKDIR /opt/vosk-server/websocket
CMD [ "python3", "./asr_server.py", "/opt/vosk-model-en-in/model" ]