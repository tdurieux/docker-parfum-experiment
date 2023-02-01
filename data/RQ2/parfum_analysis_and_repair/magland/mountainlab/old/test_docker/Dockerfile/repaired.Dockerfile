FROM magland/ubuntu-qt5-nodejs

RUN apt-get install --no-install-recommends -y libfftw3-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y octave && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y git nano htop && rm -rf /var/lib/apt/lists/*;

RUN git clone --branch master https://github.com/magland/mountainlab

WORKDIR mountainlab

RUN ./compile_components.sh prv mountainprocess mountainsort mdaconvert

ENV PATH="/mountainlab/bin:${PATH}"


