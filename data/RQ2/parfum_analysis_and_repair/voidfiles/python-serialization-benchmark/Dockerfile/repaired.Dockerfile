FROM python:3


ADD . /opt/code
WORKDIR /opt/code/

RUN pip install --no-cache-dir -r requirements.txt
CMD ["python", "benchmark.py"]
