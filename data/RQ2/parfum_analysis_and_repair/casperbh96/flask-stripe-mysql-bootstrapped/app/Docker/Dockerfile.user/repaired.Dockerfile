FROM python:3.7

COPY ./requirements.txt /app/requirements.txt

WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt

ADD ./Gunicorn/guni_user.py ./Gunicorn/guni_user.py
ADD ./UserMicroservice ./UserMicroservice

WORKDIR ./UserMicroservice

EXPOSE 5003
CMD [ "gunicorn", "-c", "../Gunicorn/guni_user.py", "main_user:app" ]