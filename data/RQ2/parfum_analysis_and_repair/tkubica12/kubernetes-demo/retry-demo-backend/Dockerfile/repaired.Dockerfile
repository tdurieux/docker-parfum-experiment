FROM python:3

ADD web.py /

RUN pip install --no-cache-dir cherrypy

CMD [ "python", "./web.py" ]

EXPOSE 80