FROM alphacep/kaldi-vosk-server:latest

ENV RUVERSION 0.22
RUN mkdir /opt/vosk-model-ru \
   && cd /opt/vosk-model-ru \
   && wget -q https://alphacephei.com/kaldi/models/vosk-model-ru-${RUVERSION}.zip \
   && unzip vosk-model-ru-${RUVERSION}.zip \
   && mv vosk-model-ru-${RUVERSION} model \
   && rm -rf model/extra \
   && rm -rf vosk-model-ru-${RUVERSION}.zip

EXPOSE 2700
WORKDIR /opt/vosk-server/websocket
CMD [ "python3", "./asr_server.py", "/opt/vosk-model-ru/model" ]
