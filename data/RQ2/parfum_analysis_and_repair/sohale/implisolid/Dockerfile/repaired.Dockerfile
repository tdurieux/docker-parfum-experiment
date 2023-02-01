FROM apiaryio/emcc:1.36


RUN apt-get install --no-install-recommends wget -y && rm -rf /var/lib/apt/lists/*;
WORKDIR /lib/
RUN wget -q -S -O - 'https://downloads.sourceforge.net/project/boost/boost/1.61.0/boost_1_61_0.tar.gz' | tar xz


RUN apt-get install --no-install-recommends mercurial -y && rm -rf /var/lib/apt/lists/*;
RUN hg clone https://bitbucket.org/eigen/eigen
WORKDIR /src