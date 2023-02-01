FROM ubuntu:21.04
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN apt update && apt install --no-install-recommends git python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/phac-nml/mob-suite.git
RUN cd mob-suite && git checkout mob-3.0.3 && cd ..
RUN apt install --no-install-recommends libcurl4-openssl-dev libssl-dev -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir Cython numpy
RUN apt install --no-install-recommends mash ncbi-blast+ -y && rm -rf /var/lib/apt/lists/*;
RUN cd mob-suite && python3 setup.py install && cd .. && rm -rf mob-suite
RUN mob_init
RUN apt clean
