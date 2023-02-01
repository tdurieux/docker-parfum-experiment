FROM python:3.7-stretch

RUN apt-get update && apt-get install --no-install-recommends -y binutils libproj-dev gdal-bin && rm -rf /var/lib/apt/lists/*;

RUN mkdir /src
WORKDIR /src
ADD requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
ADD . /src/
