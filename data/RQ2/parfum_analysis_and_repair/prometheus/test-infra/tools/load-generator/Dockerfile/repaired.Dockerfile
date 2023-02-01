FROM python:3

COPY ./requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt

COPY ./*.py /usr/src/app/

WORKDIR /usr/src/app

ENTRYPOINT ["python", "-u", "./main.py"]
