FROM qlyoung/fuzzbox:latest

RUN apt-get update && apt-get install --no-install-recommends -yqq zip unzip sysstat libcap2 gdb python3 python3-setuptools jq sqlite3 influxdb-client && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/jfoote/exploitable.git && cd exploitable && python3 setup.py install

COPY entrypoint.sh monitor-afl.sh monitor-libfuzzer.sh /
COPY analyzer /analyzer/

ENTRYPOINT [ "/entrypoint.sh" ]
