FROM quay.io/quads/python39:latest

RUN apk add git && apk update

RUN git clone https://github.com/redhat-performance/badfish

WORKDIR badfish

RUN apk add build-base
RUN pip install --no-cache-dir -r requirements.txt
RUN sed -i 's/src.badfish.helpers/.helpers/' src/badfish/badfish.py
RUN python -m build
RUN python -m pip install dist/badfish-1.0.2.tar.gz

ENTRYPOINT ["badfish"]
CMD ["-v"]
