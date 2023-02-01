FROM python:3.7
WORKDIR /workdir
RUN pip install --no-cache-dir flask
CMD ["flask", "run", "--host", "0.0.0.0"]

