FROM ann-benchmarks

RUN pip3 install --no-cache-dir cython
RUN pip3 install --no-cache-dir n2
RUN python3 -c 'import n2'
