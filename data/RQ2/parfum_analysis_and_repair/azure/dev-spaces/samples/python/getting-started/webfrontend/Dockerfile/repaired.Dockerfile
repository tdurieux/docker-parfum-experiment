FROM python:3

WORKDIR /python/webfrontend

RUN pip install --no-cache-dir flask

COPY webfrontend.py webfrontend.py
COPY public/ public/

EXPOSE 80
CMD ["python", "./webfrontend.py"]