FROM lensa/satyr:latest

ADD . /daskos
WORKDIR /daskos
RUN pip install --no-cache-dir .
