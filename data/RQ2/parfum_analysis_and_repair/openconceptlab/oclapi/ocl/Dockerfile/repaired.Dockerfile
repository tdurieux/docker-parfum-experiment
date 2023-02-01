FROM python:2.7.16
ENV PYTHONUNBUFFERED 1

RUN mkdir /code
ADD . /code/
WORKDIR /code

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000

CMD bash startup.sh