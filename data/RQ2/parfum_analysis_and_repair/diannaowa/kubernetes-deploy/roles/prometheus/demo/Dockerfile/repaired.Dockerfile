FROM python:2.7

RUN pip install --no-cache-dir prometheus_client

ADD demo.py /
EXPOSE 8000
CMD ["python","/demo.py"]
