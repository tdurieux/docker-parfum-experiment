FROM python:3.7

COPY ./requirements.txt /app/requirements.txt

WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt

ADD ./Gunicorn/guni_notification.py ./Gunicorn/guni_notification.py
ADD ./NotificationMicroservice ./NotificationMicroservice

WORKDIR ./NotificationMicroservice

EXPOSE 5002
CMD [ "gunicorn", "-c", "../Gunicorn/guni_notification.py", "main_notification:app" ]