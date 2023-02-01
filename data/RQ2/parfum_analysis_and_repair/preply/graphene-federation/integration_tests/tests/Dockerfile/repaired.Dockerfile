FROM python:3.6-alpine3.9

WORKDIR project
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

CMD [ "pytest", "-s"]
