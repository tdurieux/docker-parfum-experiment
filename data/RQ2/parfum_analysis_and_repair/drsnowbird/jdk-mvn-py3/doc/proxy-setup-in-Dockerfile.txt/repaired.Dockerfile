####################################################################
#### Usage:
#### 1.) In you ~/.bashrc (most linux), setup:
####       export http_proxy=<your_corp_proxy_host-and-port>
####       export https_proxy=<your_corp_proxy_host-and-port>
####
#### 2.) Add into the currect Xterm or Console:
####       source ~/.bashrc
####
#### 3.) Add the following code segments into the "Dockerfile" to make it fit into
####     your corporate Proxy environments
####
####################################################################

#### ==== Add the following code with your corporate Proxy servers setup to make Dockerfile to work with proxy ==== #####

#### ---- Proxy & Certificate setup ----

ENV https_proxy=${https_proxy:-http://proxy.openkbs.org:80}
ENV http_proxy=${https_proxy:-http://proxy.openkbs.org:80}
ENV no_proxy=${https_proxy:-localhost,127.0.0.1,.openkbs.org}

RUN export https_proxy=${https_proxy} && \
    export http_proxy=${https_proxy} && \
    export no_proxy=${https_proxy}

#### ---- CA Certificates locations ---- ####
# (for Ubuntu):
# Directory of CA certificates.
#       /usr/share/ca-certificates
# Directory of local CA certificates (with .crt extension).
#       /usr/local/share/ca-certificates
# (for Ubuntu):
ENV CERTIFICATE_DIR=/usr/local/share/ca-certificates
# (for CentOS)
# ENV CERTIFICATE_DIR=/etc/pki/ca-trust/source/anchors

#### --- Some example CA examples: Changed to your own specifics ---- ####
RUN \
    mkdir -p ${CERTIFICATE_DIR} && \
    wget -O ${CERTIFICATE_DIR}/openkbs-BA-Root.crt https://pki.openkbs.org/openkbs-BA-Root.crt && \
    wget -O ${CERTIFICATE_DIR}/openkbs-BA-NPE-CA-3.crt https://pki.openkbs.org/openkbs-BA-NPE-CA-3.crt && \
    wget -O ${CERTIFICATE_DIR}/openkbs-BA-NPE-CA-4.crt https://pki.openkbs.org/openkbs-BA-NPE-CA-4.crt && \
    update-ca-certificates# (for Ubuntu OS)
    # update-ca-trust extract # (for CentOS OS)

RUN sudo /usr/bin/npm config set proxy ${http_proxy} && \
    sudo /usr/bin/npm config set http_proxy ${http_proxy} && \
    sudo /usr/bin/npm config set https_proxy ${https_proxy}
