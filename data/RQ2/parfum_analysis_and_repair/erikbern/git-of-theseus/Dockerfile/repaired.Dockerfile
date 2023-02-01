FROM python:2.7.12
MAINTAINER Jim DeLois <delois@adobe.com>

COPY ./container/ /
COPY ./ /got/

RUN pip install --no-cache-dir -e /got && \
    apt-get update -q && \
    apt-get install --no-install-recommends -yqq git && rm -rf /var/lib/apt/lists/*;

#VOLUME ["/output"]

WORKDIR /got/

CMD ["python"]
