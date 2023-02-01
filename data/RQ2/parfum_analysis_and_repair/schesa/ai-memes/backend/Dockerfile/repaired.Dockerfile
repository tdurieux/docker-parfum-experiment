FROM python:3.7

RUN pip install --no-cache-dir django
RUN pip install --no-cache-dir Pillow
RUN pip install --no-cache-dir graphene_django
RUN python -m pip install grpcio
RUN python -m pip install grpcio-tools

RUN mkdir /app
ADD . /app
WORKDIR /app

# RUN python manage.py migrate

CMD ["python", "manage.py", "runserver", "0:8080"]