FROM alpine

ADD thread_busyloop.cpp .
RUN apk add --no-cache g++ && g++ thread_busyloop.cpp -o /thread_busyloop -lpthread -static && apk del g++

