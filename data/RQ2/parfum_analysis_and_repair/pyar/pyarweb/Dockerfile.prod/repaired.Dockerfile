FROM python:3.9
ENV PYTHONUNBUFFERED 1
ENV PYTHONPATH /code:$PYTHONPATH
RUN mkdir /code
WORKDIR /code
COPY prod_requirements.txt /code
COPY requirements.txt /code
RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir -r prod_requirements.txt
COPY . /code/
