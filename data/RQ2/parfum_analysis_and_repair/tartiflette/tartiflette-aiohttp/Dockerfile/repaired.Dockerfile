FROM python:3.7.2

RUN apt-get update && apt-get install --no-install-recommends -y cmake bison flex && rm -rf /var/lib/apt/lists/*;

ENV PYTHONPATH=/usr/src/app/

WORKDIR /usr/src/app

COPY . /usr/src/app/

RUN make init
RUN pip install --no-cache-dir -e .[test]