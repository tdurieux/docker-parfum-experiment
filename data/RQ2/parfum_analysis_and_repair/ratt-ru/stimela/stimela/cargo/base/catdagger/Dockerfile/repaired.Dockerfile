FROM stimela/astropy:1.2.0
RUN docker-apt-install python-casacore

RUN pip install --no-cache-dir catdagger==0.2.1

RUN dagger --help