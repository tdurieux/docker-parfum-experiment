FROM python

WORKDIR /app

COPY . .

RUN pip3 install --no-cache-dir -r ./web/requirements.txt

EXPOSE 6969

CMD python3 ./web/app.py
