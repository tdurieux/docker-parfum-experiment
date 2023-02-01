FROM ann-benchmarks

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir scann
RUN python3 -c 'import scann'
