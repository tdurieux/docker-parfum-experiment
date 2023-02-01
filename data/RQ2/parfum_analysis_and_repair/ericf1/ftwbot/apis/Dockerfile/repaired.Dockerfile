FROM python:alpine3.10

WORKDIR /app
COPY . .

RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT [ "python" ]

CMD [ "api.py" ]

