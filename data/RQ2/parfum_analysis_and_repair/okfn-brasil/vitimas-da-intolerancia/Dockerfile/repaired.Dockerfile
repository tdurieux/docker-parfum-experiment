FROM python:3.7.0-alpine

ENV PYTHONBREAKPOINT=ipdb.set_trace
WORKDIR /code

COPY requirements.txt requirements.txt

RUN apk update && \
    apk add --no-cache --virtual .build-deps build-base && \
    python -m pip pip --no-cache install -U && \
    python -m pip --no-cache install -r requirements.txt && \
    apk --purge del .build-deps && \
    rm -rfv /var/cache/apk/*

COPY .coveragerc .coveragerc
COPY pytest.ini pytest.ini
COPY clear_cache.py clear_cache.py
COPY run.py run.py
COPY victims/ victims/

CMD ["python", "run.py"]
