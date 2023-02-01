FROM python:3.8
ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get install --no-install-recommends tesseract-ocr -y && rm -rf /var/lib/apt/lists/*;
RUN mkdir /hops
WORKDIR /hops
COPY requirements.txt /hops/
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir docker
COPY . /hops/