FROM python:alpine
RUN apk add --no-cache git
RUN git clone https://github.com/mazen160/bfac.git
WORKDIR bfac
RUN python setup.py install
ENTRYPOINT ["bfac"]
