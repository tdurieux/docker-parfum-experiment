FROM python:3.6

COPY requirements.txt requirements.txt

RUN pip install --no-cache-dir -U pip wheel setuptools \
 && pip install --no-cache-dir -r requirements.txt

ADD . .

EXPOSE 5000

CMD python web.py