FROM python:2

MAINTAINER Jose Castillo <profjose.lema@fiap.com.br>

ADD api.py requirements.txt /
RUN pip install --no-cache-dir -r ./requirements.txt

ENV PORT=5000

EXPOSE $PORT
HEALTHCHECK CMD curl --fail http://localhost:$PORT || exit 1

CMD [ "./api.py" ]
