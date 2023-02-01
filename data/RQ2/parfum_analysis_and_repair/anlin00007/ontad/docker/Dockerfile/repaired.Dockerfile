FROM ubuntu:16.04

RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y file gcc g++ git make wget && rm -rf /var/lib/apt/lists/*;

RUN cd /opt && git clone https://github.com/anlin00007/OnTAD.git
RUN              cd /opt/OnTAD/src && make clean && make
ENV PATH            /opt/OnTAD/src:${PATH}

CMD /bin/bash
