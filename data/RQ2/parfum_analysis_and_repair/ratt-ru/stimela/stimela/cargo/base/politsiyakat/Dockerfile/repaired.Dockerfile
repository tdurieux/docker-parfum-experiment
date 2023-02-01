FROM stimela/base:1.2.0
RUN docker-apt-install libfreetype6-dev \
        wcslib-dev libcfitsio-dev \ 
        python-casacore
RUN pip install --no-cache-dir -U pip setuptools wheel virtualenv
RUN pip install --no-cache-dir -U politsiyakat >=0.3.7
