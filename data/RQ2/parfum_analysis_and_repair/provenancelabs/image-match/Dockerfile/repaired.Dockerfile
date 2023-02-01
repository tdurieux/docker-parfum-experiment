FROM python:3.5

RUN apt-get update && apt-get install --no-install-recommends -y libblas-dev liblapack-dev gfortran && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir numpy scipy

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY image_match /usr/src/app/image_match
COPY setup.py /usr/src/app/setup.py

RUN pip install --no-cache-dir -e .[dev]
