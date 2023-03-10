FROM redcanari/canari:{{{ canari.version }}}-alpine

RUN mkdir -p /var/plume

COPY . /root/sdist

RUN cd /root/sdist && \
    python setup.py install && \
    cd /root && \
    rm -rf /root/sdist

RUN cd /var/plume && \
    canari install-plume -y && \
    canari load-plume-package -y {{{ project.name }}}

EXPOSE 8080

ENTRYPOINT /etc/init.d/plume start-docker