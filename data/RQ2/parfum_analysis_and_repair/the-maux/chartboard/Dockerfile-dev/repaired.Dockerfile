FROM bitnami/python:3.8

RUN apt-get update && apt-get install redis-server -y --no-install-recommends \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN groupadd -g 1001 app && useradd -r -u 1001 -g app app
RUN mkdir /home/app && chown 1001 /home/app
WORKDIR /home/app

COPY src/ src/

COPY requirements-dev.txt .
RUN chown -R 1001 /home/app

ENV PATH="/home/app/.local/bin:${PATH}"
USER 1001
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir --user -r requirements-dev.txt

EXPOSE 8080

CMD ["python", "src/manage.py", "runserver", "0.0.0.0:8080", "--noreload"]
