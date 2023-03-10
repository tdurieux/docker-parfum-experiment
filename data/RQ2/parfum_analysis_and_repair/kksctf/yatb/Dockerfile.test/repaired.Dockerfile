FROM python:3.8

COPY ./requirements-dev.txt .
RUN pip install --no-cache-dir -r requirements-dev.txt

CMD [ "python3" ]