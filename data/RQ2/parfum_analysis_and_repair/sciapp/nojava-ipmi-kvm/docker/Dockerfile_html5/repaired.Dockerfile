FROM node:14
LABEL maintainer="Maximilian Heuwes <m.heuwes@fz-juelich.de>"

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl net-tools procps python-numpy \
                                               python-pip python-pyquery python-setuptools python-wheel tar && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --no-cache-dir future requests && \
    mkdir /usr/local/kvm-html5/

COPY kvm-html5/package*.json /usr/local/kvm-html5/

RUN cd /usr/local/kvm-html5/ && \
    npm install && npm cache clean --force;

COPY kvm-html5/ /usr/local/kvm-html5/

COPY get_java_viewer.py /usr/local/bin/get_java_viewer

WORKDIR /root/

EXPOSE 8080

ENTRYPOINT ["node", "/usr/local/kvm-html5/main.js"]
