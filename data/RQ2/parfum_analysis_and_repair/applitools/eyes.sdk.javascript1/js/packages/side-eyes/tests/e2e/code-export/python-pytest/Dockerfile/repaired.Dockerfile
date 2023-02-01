FROM python:latest
RUN mkdir /runner
WORKDIR /runner
COPY tests/requirements.txt .
RUN pip3 install --no-cache-dir -r ./requirements.txt
