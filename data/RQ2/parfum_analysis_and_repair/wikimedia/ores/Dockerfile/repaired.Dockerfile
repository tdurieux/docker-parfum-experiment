FROM python:3.7-slim-stretch

RUN apt-get update && apt-get install --no-install-recommends -y \
    g++ \
    gfortran \
    libblas-dev \
    liblapack-dev \
    libopenblas-dev \
    enchant \
    build-essential && rm -rf /var/lib/apt/lists/*;
COPY requirements.txt /ores/requirements.txt
COPY test-requirements.txt /ores/test-requirements.txt
RUN pip install --no-cache-dir pip --upgrade && pip install --no-cache-dir wheel && pip install --no-cache-dir nltk \
    && pip install --no-cache-dir -r /ores/requirements.txt \
    && pip install --no-cache-dir -r /ores/test-requirements.txt \
    && python -m nltk.downloader stopwords

COPY . /ores
WORKDIR /ores

EXPOSE 8080
