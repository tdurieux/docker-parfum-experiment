FROM nimlang/nim
RUN : \
    && apt-get update -y --quiet \
    && apt-get install --no-install-recommends -y curl python3-pycurl wget python3-wget python3-pip \
    && apt-get clean -y --quiet && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip==20.2.4
RUN pip3 install --no-cache-dir --upgrade requests==2.22.0
RUN pip3 install --no-cache-dir --upgrade urllib3==1.25.2
RUN nimble -y refresh ; nimble -y install nimpy@0.1.0
ADD src/faster_than_requests.nim /tmp/
RUN nim c -f -d:danger -d:ssl --app:lib --threads:on -d:noSignalHandler --listFullPaths:off --excessiveStackTrace:off --tlsEmulation:off --exceptions:goto --passL:"-s" --gc:markAndSweep --passC:"-flto -ffast-math -march=native -mtune=native -fsingle-precision-constant" --out:/tmp/faster_than_requests.so /tmp/faster_than_requests.nim
ADD server4benchmarks.nim /tmp/
RUN nim c -d:release /tmp/server4benchmarks.nim
ADD benchmark.py /tmp/
RUN rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/nimblecache/* /var/log/journal/*
EXPOSE 5000
