FROM python:3.7-buster
COPY ./requirements.txt /aries-test-harness/
WORKDIR /aries-test-harness
RUN pip install --no-cache-dir -r requirements.txt

RUN \
    echo "==> Install stuff not in the requirements..."   && \
    pip install --no-cache-dir \
        aiohttp

COPY . /aries-test-harness

ENTRYPOINT ["behave"]
