FROM arm32v7/python:3.9-slim-buster

ENV PYTHONUNBUFFERED=0

VOLUME /config

WORKDIR /usr/src/app

COPY requirements.txt .
RUN pip install --index-url=https://www.piwheels.org/simple --no-cache-dir -r requirements.txt

COPY helpers/ helpers/
COPY <SCRIPT_NAME>.py .
RUN chmod +x <SCRIPT_NAME>.py

CMD [ "python", "-u", "./<SCRIPT_NAME>.py" ]