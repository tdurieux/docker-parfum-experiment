FROM --platform=linux/amd64 python:3.9
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
RUN mkdir /code
WORKDIR /code
ADD requirements/base.txt \
    requirements/dev.txt \
    requirements/test.txt \
    /code/requirements/
RUN pip3 install --no-cache-dir -r requirements/base.txt
RUN pip3 install --no-cache-dir -r requirements/dev.txt
RUN pip3 install --no-cache-dir -r requirements/test.txt
ADD . /code/
RUN useradd -m app
USER app