FROM python:3.7-slim

WORKDIR /usr/src/histogram
COPY . /usr/src/histogram
RUN pip install --no-cache-dir -r requirements.txt

ENV HISTOGRAM_HOST "0.0.0.0"
ENV HISTOGRAM_PORT 5004

CMD ["python", "server.py"]