FROM python:3.10-alpine
WORKDIR /app
COPY requirements.txt /app
RUN apk add --no-cache ffmpeg
RUN pip3 install --no-cache-dir -r requirements.txt
COPY . /app
ENTRYPOINT ["python"]
CMD ["bbb-player.py", "--server"]
