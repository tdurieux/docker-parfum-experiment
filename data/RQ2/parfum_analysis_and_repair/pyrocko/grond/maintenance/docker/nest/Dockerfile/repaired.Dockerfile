FROM pyrocko

WORKDIR /src
RUN pip3 install --no-cache-dir utm
RUN git clone https://github.com/pyrocko/kite.git && cd kite \
    && python3 setup.py install
