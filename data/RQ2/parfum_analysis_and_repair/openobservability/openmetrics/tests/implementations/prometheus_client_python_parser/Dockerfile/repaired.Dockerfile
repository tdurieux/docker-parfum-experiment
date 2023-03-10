FROM python:latest

RUN pip install --no-cache-dir -Iv prometheus_client==0.9.0

RUN mkdir /src

ADD parser.py /src/parser.py

CMD ["python","/src/parser.py"]
