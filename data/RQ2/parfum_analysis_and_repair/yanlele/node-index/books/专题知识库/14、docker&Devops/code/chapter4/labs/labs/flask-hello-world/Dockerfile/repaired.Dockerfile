FROM python:2.7-alpine
LABEL maintainer="Peng Xiao<xiaoquwl@gmail.com>"
RUN pip install --no-cache-dir flask Flask-Script
COPY . /app/
WORKDIR /app
EXPOSE 5000
ENTRYPOINT [ "python", "manage.py" ]
CMD []