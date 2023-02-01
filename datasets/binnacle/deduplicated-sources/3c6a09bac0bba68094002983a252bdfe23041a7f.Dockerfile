FROM vulhub/ghostscript:9.21-python

LABEL maintainer="neargle <nearg1e.com@gmail.com> && phith0n <root@leavesongs.com>"

RUN set -ex \
    && pip install -U pip \
    && pip install "flask==0.12.2" "Pillow==4.2.1"
    
COPY app.py /usr/src/

WORKDIR /usr/src/

CMD ["python", "app.py"]