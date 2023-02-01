FROM python:3.5
MAINTAINER Channel Cat <channelcat@gmail.com>

ADD . /code
RUN pip3 install --no-cache-dir git+https://github.com/channelcat/sanic
RUN pip3 install --no-cache-dir pycryptodome

EXPOSE 3001

WORKDIR /code

CMD ["python", "main.py"]