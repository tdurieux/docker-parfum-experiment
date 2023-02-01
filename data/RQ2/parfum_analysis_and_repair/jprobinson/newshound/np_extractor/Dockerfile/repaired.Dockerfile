FROM python:2.7-alpine3.8

ADD *.py /

ADD nltk_data /nltk_data

RUN pip install --no-cache-dir -U nltk
RUN pip install --no-cache-dir -U simplejson

CMD python service.py
