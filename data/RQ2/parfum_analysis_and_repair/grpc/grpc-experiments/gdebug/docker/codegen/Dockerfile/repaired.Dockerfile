FROM channelz_grpc_web_prereqs:latest

RUN cd /github/grpc-web/javascript/net/grpc/web/ && make

RUN cd /github/grpc-web && \
  curl -f https://dl.google.com/closure-compiler/compiler-latest.zip \
  -o compiler-latest.zip && \
  rm -f closure-compiler.jar && \
  unzip -p -qq -o compiler-latest.zip *.jar > closure-compiler.jar

