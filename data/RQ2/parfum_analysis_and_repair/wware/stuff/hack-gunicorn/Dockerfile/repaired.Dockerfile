FROM ubuntu

RUN apt-get update && apt-get install --no-install-recommends -y python-pip python-dev nginx vim && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir gunicorn flask

COPY foo.py /
COPY wsgi.py /

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "wsgi"]
