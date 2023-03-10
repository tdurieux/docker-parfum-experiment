FROM arm32v7/python:3.7-slim-buster

WORKDIR /app

RUN pip install --no-cache-dir ptvsd==4.1.3

COPY ./app/requirements.txt ./
RUN pip install --no-cache-dir -r ./requirements.txt

COPY ./app .

CMD [ "python3", "-u", "./main.py" ]