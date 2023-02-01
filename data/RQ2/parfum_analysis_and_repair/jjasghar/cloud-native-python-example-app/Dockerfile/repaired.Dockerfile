FROM python:3.7.7-slim

ENV PYTHONUNBUFFERED=1

COPY * /opt/microservices/
COPY requirements.txt /opt/microservices/
RUN pip install --no-cache-dir --upgrade pip \
  && pip install --no-cache-dir --upgrade pipenv \
  && apt-get clean \
  && apt-get update \
  && apt install --no-install-recommends -y build-essential \
  && apt install --no-install-recommends -y libmariadb3 libmariadb-dev \
  && pip install --no-cache-dir --upgrade -r /opt/microservices/requirements.txt && rm -rf /var/lib/apt/lists/*;

USER 1001

EXPOSE 8080
WORKDIR /opt/microservices/

CMD ["python", "app.py", "8080"]