FROM python:3.8

ENV APP_DIR=/app

COPY ./start-fastapi.tar.gz /

RUN mkdir -p $APP_DIR \
    && tar xvf /start-fastapi.tar.gz --directory $APP_DIR \
    && cd $APP_DIR \
    && pip3 install --no-cache-dir -r ./requirements.txt && rm /start-fastapi.tar.gz

EXPOSE 8000

WORKDIR $APP_DIR

CMD ["python3", "main.py", "-e", "prod", "-t", "start-fastapi"]
