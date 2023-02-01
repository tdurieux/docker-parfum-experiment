FROM python:3.8-slim

RUN pip3 install --no-cache-dir --upgrade pip && pip3 install --no-cache-dir rq-scheduler

CMD [ "rqscheduler", "--host", "kontext_redis_1", "--db", "2", "-i", "10" ]
