FROM python:3.6-alpine
RUN apk add --no-cache --update build-base libffi-dev
RUN apk add --no-cache --update postgresql-dev
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
ADD . /code
WORKDIR /code
RUN pip install --no-cache-dir ./rws-common
ENV FLASK_ENV=development
CMD ["flask", "run", "-h", "0.0.0.0"]
