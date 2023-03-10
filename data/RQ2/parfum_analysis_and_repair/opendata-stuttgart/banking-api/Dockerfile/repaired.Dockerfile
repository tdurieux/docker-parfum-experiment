FROM python:3.6
MAINTAINER Stuttgart Python Interest Group

EXPOSE 8010

USER root
RUN apt-get update && apt-get install --no-install-recommends -y ttf-dejavu-core && rm -rf /var/lib/apt/lists/*;
RUN easy_install -U pip

ADD requirements.txt /opt/code/requirements.txt
WORKDIR /opt/code
RUN pip3 install --no-cache-dir --find-links=http://pypi.qax.io/wheels/ --trusted-host pypi.qax.io -Ur requirements.txt
ADD . /opt/code

RUN chown -R 1000 /opt

WORKDIR /opt/code/banking

USER root

# production stuff
ENTRYPOINT ["./start.sh"]
CMD ["web"]
