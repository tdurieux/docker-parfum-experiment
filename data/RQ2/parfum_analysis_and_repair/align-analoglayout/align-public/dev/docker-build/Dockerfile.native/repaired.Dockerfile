FROM ubuntu:18.04

RUN \
    apt-get update && \
    apt-get install --no-install-recommends -yq \
         vim make cmake git \
					pkg-config python3 python3-pip python3-venv \
					docker-compose emacs sudo \
					graphviz libgraphviz-dev protobuf-compiler && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN \
    python3 -m venv general && \
    bash -c "source general/bin/activate; pip install --upgrade pip && pip install wheel pytest general networkx pygraphviz coverage pytest-cov protobuf matplotlib pyyaml python-gdsii"

COPY . /ALIGN-public

RUN \
    bash -c "source general/bin/activate; cd /ALIGN-public/GDSConv && pip install ."

RUN \
    bash -c "source general/bin/activate; cd ALIGN-public/CellFabric && pip install ."


RUN \
    git clone https://www.github.com/ALIGN-analoglayout/lpsolve.git  && \
    cp -r lpsolve /usr/local/lib/

RUN \
    apt-get update && \
    apt-get install --no-install-recommends -yq libboost-all-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN \
    cd /opt && \
    git clone https://github.com/google/googletest.git && \
    cd googletest && \
    git checkout c9ccac7cb7345901884aabf5d1a786cfa6e2f397 && \
    cd googletest && \
    mkdir mybuild && \
    cd mybuild && \
    cmake .. && \
    make

ENV LD_LIBRARY_PATH=/usr/local/lib/lpsolve/lp_solve_5.5.2.5_dev_ux64

RUN \
    cd opt && \
    git clone https://github.com/nlohmann/json.git

RUN \
    bash -c "cd /ALIGN-public/PlaceRouteHierFlow; make"


RUN \
    apt-get install --no-install-recommends -yq curl && rm -rf /var/lib/apt/lists/*;

RUN \
    bash -c "curl -o /klayout_0.25.4-1_amd64.deb https://www.klayout.org/downloads/Ubuntu-18/klayout_0.25.4-1_amd64.deb"

RUN \
    apt-get install --no-install-recommends -yq /klayout_0.25.4-1_amd64.deb xvfb && rm -rf /var/lib/apt/lists/*;

WORKDIR /dataVolume
