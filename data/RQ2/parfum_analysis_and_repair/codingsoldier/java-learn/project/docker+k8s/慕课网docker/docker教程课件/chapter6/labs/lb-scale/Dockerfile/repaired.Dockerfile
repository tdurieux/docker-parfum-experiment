FROM python:2.7
LABEL maintaner="Peng Xiao xiaoquwl@gmail.com"
COPY . /app
WORKDIR /app
RUN pip install --no-cache-dir flask redis
EXPOSE 80
CMD [ "python", "app.py" ]