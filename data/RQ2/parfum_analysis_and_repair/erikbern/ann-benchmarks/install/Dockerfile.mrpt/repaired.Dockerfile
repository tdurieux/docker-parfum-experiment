FROM ann-benchmarks

RUN pip3 install --no-cache-dir sklearn
RUN pip3 install --no-cache-dir git+https://github.com/vioshyvo/mrpt
