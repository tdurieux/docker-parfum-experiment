FROM python:3.8-slim
MAINTAINER Sergio Ramírez  "sergio@localhost"
COPY ./requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
COPY bootcamp.py /app/
ENTRYPOINT [ "python" ]
CMD [ "bootcamp.py" ]
EXPOSE 8080
