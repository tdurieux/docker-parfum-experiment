FROM python:2.7.13
ADD snippet.py snippet.py
RUN ["pip", "install", "falcon"]
RUN ["pip", "install", "gevent"]
RUN ["pip", "install", "gevent"]
RUN ["pip", "install", "gevent"]
CMD ["python", "snippet.py"]