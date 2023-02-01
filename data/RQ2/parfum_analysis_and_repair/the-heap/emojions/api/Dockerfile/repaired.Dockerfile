FROM python:3.5.2-alpine

ENV BIND_PORT 5000
ENV HOME=/home/app

COPY ./requirements.txt $HOME/api/
COPY ./app.py $HOME/api/

EXPOSE $BIND_PORT

WORKDIR $HOME/api
RUN pip install --no-cache-dir -r ./requirements.txt

CMD [ "python", "./app.py" ]
