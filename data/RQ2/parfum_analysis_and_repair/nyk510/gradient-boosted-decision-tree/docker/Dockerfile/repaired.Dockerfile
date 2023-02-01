FROM python:3

ADD requirements.txt requirements.txt
RUN pip install --no-cache-dir -U pip && \
  pip install --no-cache-dir -r requirements.txt