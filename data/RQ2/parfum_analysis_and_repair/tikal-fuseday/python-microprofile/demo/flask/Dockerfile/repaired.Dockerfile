FROM tiangolo/uwsgi-nginx-flask:python3.7

COPY ./requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt

COPY ./app /app
ENTRYPOINT [ "python" ]
CMD [ "main.py" ]
