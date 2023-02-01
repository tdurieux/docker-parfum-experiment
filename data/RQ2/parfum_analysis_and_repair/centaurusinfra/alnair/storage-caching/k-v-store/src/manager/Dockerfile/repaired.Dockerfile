# FROM python:3.8-alpine
FROM ubuntu:20.04
RUN apt update && apt install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN mkdir app
WORKDIR /app
COPY manager ./
COPY grpctool ./grpctool
RUN pip install --no-cache-dir -r requirements.txt
RUN chmod +x *
CMD [ "python3", "manager.py" ]