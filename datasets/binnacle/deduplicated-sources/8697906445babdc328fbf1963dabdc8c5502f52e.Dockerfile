FROM python:3

COPY requirements.txt /usr/src/app/
RUN pip install -r /usr/src/app/requirements.txt

COPY main.py /usr/src/app/

WORKDIR /usr/src/app

ENTRYPOINT ["python", "-u", "./main.py"]
