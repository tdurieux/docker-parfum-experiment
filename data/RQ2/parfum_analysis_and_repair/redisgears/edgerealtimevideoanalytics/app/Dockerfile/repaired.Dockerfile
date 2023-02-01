FROM python:3.7.12

WORKDIR /app
ADD . /app
RUN apt-get update -qyy && apt-get install --no-install-recommends -y python3-opencv && rm -rf /var/lib/apt/lists/*;
RUN apt-get remove -y python3-opencv

RUN pip install --no-cache-dir --upgrade pip
RUN set -ex; \
    pip install --no-cache-dir -r requirements.txt;
RUN rm -rf ~/.cache/pip /var/cache/apt/

ENTRYPOINT [ "python3" ]
