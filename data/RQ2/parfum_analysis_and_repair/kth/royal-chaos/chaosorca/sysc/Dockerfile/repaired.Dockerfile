FROM python:3.7-alpine
RUN apk --no-cache add \
  strace
WORKDIR /usr/src/app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
# run the main script.
CMD [ "python", "./main.py" ]