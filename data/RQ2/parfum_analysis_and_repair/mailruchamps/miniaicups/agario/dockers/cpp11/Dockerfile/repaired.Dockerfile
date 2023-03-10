FROM ubuntu:16.04
MAINTAINER Boris Kolganov <b.kolganov@corp.mail.ru>

ENV COMPILED_FILE_PATH=/opt/client/a.out
ENV SOLUTION_CODE_ENTRYPOINT=main.cpp
ENV COMPILATION_COMMAND='g++ -m64 -pipe -O2 -std=c++11 -pthread -w -o $COMPILED_FILE_PATH $SOLUTION_CODE_PATH/main.cpp  2>&1 > /dev/null'
ENV RUN_COMMAND='/lib64/ld-linux-x86-64.so.2 $MOUNT_POINT'

COPY ./nlohmann ./nlohmann