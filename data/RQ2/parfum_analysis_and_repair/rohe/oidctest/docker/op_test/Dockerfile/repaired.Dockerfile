FROM ubuntu:18.04
MAINTAINER hans.zandbelt@oidf.org

RUN apt-get clean && apt-get --fix-missing update
RUN apt-get update && apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y build-essential libssl-dev libffi-dev python3-dev && rm -rf /var/lib/apt/lists/*;
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y git ntp psmisc python3-pytest && rm -rf /var/lib/apt/lists/*;

ENV SRCDIR /usr/local/src
ENV INSTDIR oidf
ENV SUBDIR ${SRCDIR}/${INSTDIR}/oidc_op

WORKDIR ${SRCDIR}

#ENV PYOIDC_VERSION=dcbf2fa41e4050d8c077992d3481fc3967824c5d
#RUN git clone https://github.com/OpenIDC/pyoidc.git
#RUN cd pyoidc && git fetch origin && git checkout ${PYOIDC_VERSION} -b temp
#RUN cd pyoidc && python3 setup.py install

RUN git clone https://github.com/openid-certification/otest.git
RUN cd otest && python3 setup.py install && cd -

RUN mkdir oidctest
COPY . ${SRCDIR}/oidctest/
RUN cd oidctest && python3 setup.py install && cd -
RUN cd oidctest/tests && python3 -m pytest -x && cd -

RUN oidc_setup.py ${SRCDIR}/oidctest ${INSTDIR}
COPY docker/op_test/cert.pem ${SUBDIR}/certs/
COPY docker/op_test/key.pem ${SUBDIR}/certs/
COPY docker/op_test/config.py ${SUBDIR}/
COPY docker/op_test/tt_config.py ${SUBDIR}/

COPY docker/op_test/https%3A%2F%2Fop%3A4433 ${SUBDIR}/entities/https%3A%2F%2Fop%3A4433
COPY docker/op_test/assigned_ports.json ${SUBDIR}/
COPY docker/op_test/my_jwks_60003.json ${SUBDIR}/static/jwks_60003.json

COPY docker/op_test/run.sh ${SUBDIR}/

WORKDIR ${SUBDIR}
ENTRYPOINT ["./run.sh"]
