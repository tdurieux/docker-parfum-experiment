FROM python:3
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY requirements.txt /usr/src/app
RUN pip3 install --no-cache-dir -r requirements.txt
COPY ./flask-api/src /usr/src/app
EXPOSE 5000
CMD ["python3", "main.py"]
