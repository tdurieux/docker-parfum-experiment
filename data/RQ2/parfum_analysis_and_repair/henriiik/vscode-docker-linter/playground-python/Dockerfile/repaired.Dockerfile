FROM python

ENV PYTHONUNBUFFERED 1

RUN pip install --no-cache-dir Flask
RUN pip install --no-cache-dir flake8

RUN mkdir /code
ADD . /code/

WORKDIR /code
CMD python web.py