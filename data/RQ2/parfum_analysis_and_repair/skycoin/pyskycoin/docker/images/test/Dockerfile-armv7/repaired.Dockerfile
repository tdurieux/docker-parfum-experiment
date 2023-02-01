FROM balenalib/armv7hf-debian-python

ENV REPO_ROOT=$GOPATH/src/github.com/skycoin/pyskycoin/
ADD . ${REPO_ROOT}
ENV PIP='python3 -m pip'

RUN [ "cross-build-start" ]

#Install package
RUN apt-get update && apt-get install --no-install-recommends make cmake python3-dev python3-pip python3-setuptools python3-pytest libpcre3-dev curl gcc -y && rm -rf /var/lib/apt/lists/*;

# Install packages in PIP_PACKAGES
RUN ${PIP} install -i https://test.pypi.org/simple/ pyskycoin

RUN cd ${REPO_ROOT} && python3 -m pytest tests/*.py

RUN [ "cross-build-end" ]