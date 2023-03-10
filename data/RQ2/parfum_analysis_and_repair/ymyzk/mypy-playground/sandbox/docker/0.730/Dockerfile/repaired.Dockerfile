FROM python:3.8-slim

WORKDIR /tmp
COPY ./requirements.txt /tmp/

RUN pip install --no-cache-dir -r requirements.txt \
        && rm -rf /tmp/requirements.txt \
        && rm -rf /root/.cache

USER nobody
CMD ["mypy"]
