FROM pypy:3.6

ADD . /app

WORKDIR /app

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir --upgrade setuptools

RUN apt-get update && apt-get install --no-install-recommends build-essential libatlas3-base libatlas-base-dev -y && rm -rf /var/lib/apt/lists/*;
RUN pypy3 -m pip install numpy==1.16.4
RUN pypy3 -m pip install scipy

RUN pip install --no-cache-dir -r/app/requirements/dev.txt && \
    pip install --no-cache-dir -e .

ENTRYPOINT ["d3a"]

