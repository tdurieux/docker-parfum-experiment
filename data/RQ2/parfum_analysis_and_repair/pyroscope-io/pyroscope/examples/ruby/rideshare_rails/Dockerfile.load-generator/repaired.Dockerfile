FROM python:3.9

RUN pip3 install --no-cache-dir requests

COPY load-generator.py ./load-generator.py

ENV PYTHONUNBUFFERED=1
CMD [ "python", "load-generator.py" ]


