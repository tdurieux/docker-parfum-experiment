FROM python:3.7-alpine
COPY . /app
WORKDIR /app
RUN date
RUN apk add --no-cache tzdata
RUN apk add --no-cache build-base
RUN cp /usr/share/zoneinfo/America/New_York /etc/localtime
RUN echo "America/New_York" > /etc/timezone
RUN date
RUN pip install --no-cache-dir -r requirements.txt
CMD [ "python", "-u", "src/server.py" ]