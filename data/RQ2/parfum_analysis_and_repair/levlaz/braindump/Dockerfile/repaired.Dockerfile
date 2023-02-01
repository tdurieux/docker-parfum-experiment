FROM python:3.5
ENV PYTHONUNBUFFERED 1

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY requirements.txt /usr/src/app
RUN pip install --no-cache-dir --upgrade -r requirements.txt
COPY . /usr/src/app