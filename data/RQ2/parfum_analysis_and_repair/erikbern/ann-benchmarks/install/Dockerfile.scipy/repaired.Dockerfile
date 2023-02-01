FROM ann-benchmarks

RUN pip3 install --no-cache-dir scipy
RUN python3 -c 'import scipy'
