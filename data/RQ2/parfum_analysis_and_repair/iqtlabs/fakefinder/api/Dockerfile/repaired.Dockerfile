FROM python:3.6

ENV PROJECT_DIR /usr/src/fakefinder-api

WORKDIR ${PROJECT_DIR}

COPY . .

RUN apt-get update && apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install -r requirements.txt

ENV PYTHONUNBUFFERED 1
EXPOSE 5000

CMD ["python3", "api.py"]
