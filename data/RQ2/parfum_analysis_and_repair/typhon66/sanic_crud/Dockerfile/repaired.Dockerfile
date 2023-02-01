FROM python:3.6

ADD . /code
WORKDIR /code

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -r /code/dev-requirements.txt
RUN pip3 install --no-cache-dir -e .

EXPOSE 8000

CMD ["python", "dev_server.py"]