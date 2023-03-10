FROM python:3.7-alpine

RUN adduser -S app app

RUN mkdir /code/
COPY . /code/

WORKDIR /code/
RUN pip install --no-cache-dir .

USER app
WORKDIR /workspace/
ENTRYPOINT ["ecs-deplojo"]
