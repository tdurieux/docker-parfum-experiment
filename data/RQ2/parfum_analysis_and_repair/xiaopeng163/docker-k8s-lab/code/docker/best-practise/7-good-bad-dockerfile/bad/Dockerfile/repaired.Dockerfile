# DO NOT USE THIS DOCKERFILE AS AN EXAMPLE, IT IS BROKEN
FROM python:3

COPY yourscript.py /

RUN pip install --no-cache-dir flask

CMD [ "python", "./yourscript.py" ]