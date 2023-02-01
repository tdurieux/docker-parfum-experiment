FROM python:3.6

COPY . /opt/pywebhooks
WORKDIR /opt/pywebhooks

RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -e .

EXPOSE 8081
