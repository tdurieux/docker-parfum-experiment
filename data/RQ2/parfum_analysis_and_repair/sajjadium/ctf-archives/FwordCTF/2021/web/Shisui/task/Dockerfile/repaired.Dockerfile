FROM python:alpine3.7
COPY ./task /app
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5000
CMD python app.py
