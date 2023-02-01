FROM kernsuite/base:1

RUN docker-apt-install wsclean

RUN pip install --no-cache-dir kliko

ADD kliko.yml /
ADD kliko /
CMD /usr/bin/wsclean
