FROM python:3.6.12-slim

RUN apt update

RUN mkdir /web

WORKDIR /root

COPY requirements.txt /web/requirements.txt
RUN python -m pip install -r /web/requirements.txt --no-cache-dir

WORKDIR /web

COPY . /web

ENV PORT 5000

EXPOSE ${PORT}

CMD ["python","initialize.py","&&","gunicorn", "-b","0.0.0.0:$PORT","gavel:app","-w","3"]
