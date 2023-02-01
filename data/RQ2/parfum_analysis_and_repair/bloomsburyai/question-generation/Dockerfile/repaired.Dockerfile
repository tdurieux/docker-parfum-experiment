FROM ubuntu:latest
MAINTAINER Tom Hosking "code@tomho.sk"

RUN apt-get update -y && apt-get install --no-install-recommends -y python3 python3-pip python3-dev build-essential && rm -rf /var/lib/apt/lists/*;

COPY ./requirements.txt /app/requirements.txt

WORKDIR /app
RUN pip3 install --no-cache-dir -r requirements.txt

RUN python3 -m nltk.downloader punkt
RUN python3 -m spacy download en

ADD ./src /app/src
WORKDIR /app
ENV PYTHONPATH "${PYTHONPATH}:./src"
ENTRYPOINT ["python3"]
CMD ["-u", "src/demo/app.py"]
# CMD ["bash", 'demo.sh']