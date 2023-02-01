FROM python:alpine3.7
RUN pip3 install --no-cache-dir --upgrade pip

RUN apk update && apk add --no-cache python3-dev \
                        gcc \
                        libc-dev \
			libffi-dev
COPY ./app /app
COPY ./app/server.crt /
COPY ./app/server.key /
WORKDIR /app
RUN pip3 install --no-cache-dir -r requirements.txt
EXPOSE 5000
CMD python app.py
