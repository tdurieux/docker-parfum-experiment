FROM ann-benchmarks

RUN pip3 install --no-cache-dir datasketch
RUN python3 -c 'import datasketch'
