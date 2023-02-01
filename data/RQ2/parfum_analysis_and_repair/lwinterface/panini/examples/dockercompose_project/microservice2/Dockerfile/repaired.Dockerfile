FROM python:3.8.3-buster

RUN pip install --no-cache-dir --upgrade pip
ADD requirements.txt /
RUN pip install --no-cache-dir -r requirements.txt

CMD [ "cd", "app/microservice2" ]
WORKDIR ./app

CMD [ "./microservice2/run.sh" ]

