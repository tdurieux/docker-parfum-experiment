FROM python:3
ENV PYTHONUNBUFFERED 1
RUN mkdir /code
WORKDIR /code
ADD testproject/requirements.txt /code/
RUN pip install --no-cache-dir -r requirements.txt
ADD . /code/
RUN pip install --no-cache-dir -e .
