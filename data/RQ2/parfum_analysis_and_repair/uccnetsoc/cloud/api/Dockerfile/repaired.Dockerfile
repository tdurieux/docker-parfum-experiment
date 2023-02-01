FROM tiangolo/uvicorn-gunicorn-fastapi:python3.8 AS dev


FROM tiangolo/uvicorn-gunicorn-fastapi:python3.8 AS prod
RUN apt-get update && apt-get install -y --no-install-recommends pigz && apt-get clean && rm -rf /var/lib/apt/lists/*;
COPY ./v1 /app/v1
COPY requirements.txt /requirements.txt

RUN pip3 install --no-cache-dir -r /requirements.txt

ENV MODULE_NAME=v1.main
ENV VARIABLE_NAME=api

ENTRYPOINT [ "start.sh" "--host", "0.0.0.0", "--port", "8080" ]