FROM alphacep/kaldi-vosk-server

RUN cd /opt \
  && wget -q https://boostorg.jfrog.io/artifactory/main/release/1.76.0/source/boost_1_76_0.tar.gz \
  && tar xzf boost_1_76_0.tar.gz \
  && rm boost_1_76_0.tar.gz

RUN cd /opt/vosk-server/websocket-cpp \
    && g++ -std=c++17 -O3 -I/opt/boost_1_76_0 -I/opt/vosk-api/src -o asr_server asr_server.cpp -L/opt/vosk-api/src -Wl,-rpath=/opt/vosk-api/src -lvosk -lpthread -ldl \
    && strip asr_server

RUN rm -rf /opt/boost_1_76_0