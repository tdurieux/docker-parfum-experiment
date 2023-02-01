FROM alpine

WORKDIR Dictu

RUN apk add git make curl-dev gcc libc-dev cmake --no-cache

RUN git clone https://github.com/dictu-lang/Dictu.git

RUN cd Dictu \
    && cmake -DCMAKE_BUILD_TYPE=Release -B build \
    && cmake --build ./build \
    && ./dictu tests/runTests.du \
    && cp dictu /usr/bin/ \
    && rm -rf * 

CMD ["dictu"]