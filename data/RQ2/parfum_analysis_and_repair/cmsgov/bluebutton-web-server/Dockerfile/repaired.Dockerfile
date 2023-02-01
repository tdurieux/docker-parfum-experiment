FROM python:3.7.10
ENV PYTHONUNBUFFERED 1
# ENV PYTHONDEVMODE 1
RUN mkdir /code
ADD . /code/
WORKDIR /code
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir pip-tools
RUN make reqs-install-dev
