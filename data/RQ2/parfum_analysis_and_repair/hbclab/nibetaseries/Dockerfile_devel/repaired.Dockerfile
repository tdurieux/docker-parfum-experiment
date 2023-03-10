FROM hbclab/nibetaseries:unstable

USER root

ARG DEBIAN_FRONTEND="noninteractive"

# net-tools needed for code-server
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        net-tools \
        git \
        nano && rm -rf /var/lib/apt/lists/*;

ENV SHELL=/bin/bash

# necessary to find nibetaseries in /src/nibetaseries
ENV PYTHONNOUSERSITE=0

USER neuro

RUN /bin/bash -c "cd /src/nibetaseries &&\
    conda init bash &&\
    source /home/neuro/.bashrc &&\
    source activate neuro_py36 &&\
    pip install --no-use-pep517 -e .[test,dev,doc,nb]"

USER root

RUN cp -R /src/nibetaseries/src/nibetaseries.egg-info /src/

# set up code-server (need net-tools for initialization)
RUN curl -f -o /tmp/code-server.tar.gz -SL https://github.com/cdr/code-server/releases/download/2.1523-vsc1.38.1/code-server2.1523-vsc1.38.1-linux-x86_64.tar.gz

RUN mkdir /src/codeserver && \
    tar -xvf /tmp/code-server.tar.gz -C /src/codeserver --strip-components=1 && rm /tmp/code-server.tar.gz

RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    npm i \
        vscode-nls@4.0.0 \
        mkdirp@0.5.1 \
        getos@3.1.1 \
        http-proxy-agent@2.1.0 \
        https-proxy-agent@2.2.1 \
        lodash.throttle@4.1.1 \
        meaw@4.1.0 \
        tmp@0.0.33 \
        vscode-languageclient@3.5.0 \
        yauzl@2.10.0 && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

USER neuro

RUN /src/codeserver/code-server --install-extension eamodio.gitlens &&\
    /src/codeserver/code-server --install-extension ms-python.python &&\
    /src/codeserver/code-server --install-extension lextudio.restructuredtext

ENTRYPOINT ["/src/codeserver/code-server", "/src/nibetaseries"]

# usage example (assuming in local nibetaseries directory):
#
# docker run -it \
# -p 127.0.0.1:8445:8080 \
# -v ${PWD}:/src/nibetaseries \
# nibetaseries_devel:latest
#
# then type 127.0.0.1:8445 in your browser address bar
