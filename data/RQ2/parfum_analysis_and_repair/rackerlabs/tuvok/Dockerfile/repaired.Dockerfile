FROM python:3-alpine
LABEL maintainer="Rackspace"

ENV PATH="/root/.local/bin:${PATH}"

# Install packages/updates/dependencies
RUN apk --update --no-cache add git openssh curl jq gcc build-base

ADD . /tuvok
WORKDIR /tuvok
RUN pip3 install --no-cache-dir --user -r test-requirements.txt
RUN pip3 install --no-cache-dir --user -r requirements.txt
RUN pip3 install --no-cache-dir --user -e .

WORKDIR /root
ENTRYPOINT [ "/bin/sh", "-c" ]
CMD [ "tuvok" ]
