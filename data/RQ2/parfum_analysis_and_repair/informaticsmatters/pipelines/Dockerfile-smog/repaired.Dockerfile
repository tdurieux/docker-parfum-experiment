FROM informaticsmatters/rdkit_pipelines:latest
LABEL maintainer="Tim Dudgeon<tdudgeon@informaticsmatters.com>"


USER root

RUN echo 'deb http://deb.debian.org/debian experimental main' >> /etc/apt/sources.list

RUN apt-get update -y && apt-get install --no-install-recommends -t experimental libopenbabel-dev g++ -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/local
RUN wget https://sourceforge.net/projects/opengrowth/files/SMoG2016.tar.gz/download -O smog.tar.gz &&\
  tar xfz smog.tar.gz &&\
  rm smog.tar.gz &&\
  g++ -O3 -Wall -std=c++11 -Wno-uninitialized -I/usr/include/openbabel-2.0 -lm -c /usr/local/SMoG2016/SMoG2016.cpp -o /usr/local/SMoG2016/SMoG2016.o &&\
  g++ /usr/local/SMoG2016/SMoG2016.o -o /usr/local/SMoG2016/SMoG2016.exe -rdynamic /usr/lib/libopenbabel.so -Wl,-rpath,/usr/lib

ARG USERID=1001

RUN useradd -u $USERID -g 0 -m smog

# The CMD is simply to run 'execute' in the WORKDIR.
# The user would normally mount a volume with their own execute
# script in it and then set the WORKDIR to the directory it's in.
# In its absence we just run the built-in 'execute',
# which is expected to echo some descriptive/helpful text.
#
# The default 'execute' relies on an ENV to name the pipeline it's in,
# which can be defined with the docker 'pipeline' build argument.
ARG pipeline=informaticsmatters/smog:latest
ENV PIPELINE=$pipeline
WORKDIR /home/smog
COPY execute ./
RUN chown $USERID:0 ./execute && \
    chmod +x ./execute
CMD ["./execute"]

USER $USERID
