FROM python:alpine3.7
#RUN pip install --upgrade pip
COPY ./app /app
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5000
CMD python app.py
