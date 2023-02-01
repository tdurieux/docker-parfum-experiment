ARG PYTHON=3.10
FROM python:${PYTHON}-alpine

WORKDIR /opt/pretenders
ENV PYTHONPATH=/opt/pretenders
EXPOSE 8000

COPY requirements/ requirements/

RUN apk --no-cache add \
        bash \
        make \
    && \
    pip3 install --no-cache-dir -r /opt/pretenders/requirements/test.txt

RUN ln -s /usr/bin/python3 /usr/bin/python

COPY pretenders/ pretenders/

COPY docs/ docs/

COPY *.sh ./

CMD ["/bin/ash", "build.sh"]
