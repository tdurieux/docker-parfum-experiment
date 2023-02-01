FROM python:3-alpine3.7
RUN pip3 install --no-cache-dir Flask==0.11.1 && pip install --no-cache-dir requests==2.18.4
COPY ./service.py /opt/service.py
ENTRYPOINT ["python", "/opt/service.py"]
