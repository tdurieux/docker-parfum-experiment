FROM python:3-alpine
RUN pip3 install --no-cache-dir flask
COPY app.py /opt/app.py
CMD ["python3", "/opt/app.py"]