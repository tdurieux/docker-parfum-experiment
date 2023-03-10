FROM python:3.6

COPY . /app
WORKDIR /app


RUN pip install --no-cache-dir -r requirements.txt

ENV APP_ENTRY_POINT "python app/app.py"

COPY start-with-appd.sh .

EXPOSE 8080

ENTRYPOINT ["./start-with-appd.sh"]
