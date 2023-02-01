FROM python:3.8.3-buster

RUN pip install --no-cache-dir --upgrade pip
ADD requirements.txt /
RUN pip install --no-cache-dir -r requirements.txt

CMD [ "cd", "app/microservice1" ]
WORKDIR ./app

CMD [ "./microservice1/run.sh" ]

