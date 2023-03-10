FROM python:3.7

RUN mkdir /app
WORKDIR /app
ADD . /app/
RUN apt-get upgrade -y
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -r requirements.txt

EXPOSE 5000
CMD ["python3", "/app/GE_SCH_local_scheduler.py"]