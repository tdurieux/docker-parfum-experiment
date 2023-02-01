FROM python:alpine

RUN mkdir /code
COPY . /code
WORKDIR /code

# Install the project requirements
RUN pip install --no-cache-dir .
RUN pip install --no-cache-dir pytest
