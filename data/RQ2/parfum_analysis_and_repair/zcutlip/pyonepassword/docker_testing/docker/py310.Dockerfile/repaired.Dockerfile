FROM python:3.10

RUN pip install --no-cache-dir tox
RUN useradd -ms /bin/bash unpriv

USER unpriv
ENV TOX_WORKDIR=.tox-docker
ENV TESTDIR=/usr/src/testdir
ENV PYTEST_ENV=py310
COPY test.sh /test.sh
CMD [ "/test.sh" ]
