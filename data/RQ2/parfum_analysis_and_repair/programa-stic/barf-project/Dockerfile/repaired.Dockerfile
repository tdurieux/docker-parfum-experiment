FROM ubuntu:18.04
MAINTAINER Christian Heitman

RUN apt-get -y update && \
    apt-get install --no-install-recommends -y graphviz z3 python-pip git && rm -rf /var/lib/apt/lists/*;

RUN useradd -m barf
USER barf
WORKDIR /home/barf
ENV HOME /home/barf

RUN git clone https://github.com/programa-stic/barf-project.git && \
    cd barf-project && \
    pip install --no-cache-dir .

CMD ["/bin/bash"]
