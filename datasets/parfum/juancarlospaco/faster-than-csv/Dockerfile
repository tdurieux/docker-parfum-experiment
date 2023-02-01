FROM nimlang/nim
RUN rm -rf /tmp/*
RUN apt-get update -y --quiet ; apt-get install -y python3-pip python3-numpy
RUN pip3 install --upgrade pip==21.1.1 ; pip3 install --upgrade pandas==0.24.2 ; pip3 install --upgrade matplotlib==3.4.2
RUN nimble -y refresh ; nimble -y install nimpy@0.1.1
ADD faster_than_csv/faster_than_csv.nim /tmp/
RUN nim c -d:danger -d:lto -d:strip --app:lib --gc:arc --panics:on --tlsEmulation:off --passC:"-march=native -ffast-math -fsingle-precision-constant" --out:/tmp/faster_than_csv.so /tmp/faster_than_csv.nim
ADD benchmark.py /tmp/
ADD examples/sample.csv /tmp/
ADD run-benchmark.sh /tmp/
RUN rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/nimblecache/ /tmp/*.nim
