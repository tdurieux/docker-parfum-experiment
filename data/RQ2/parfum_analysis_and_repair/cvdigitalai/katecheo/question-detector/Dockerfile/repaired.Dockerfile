FROM python:3.6-alpine
COPY . /app
WORKDIR /app
RUN pip3 install --no-cache-dir -r requirements.txt
ENTRYPOINT python3 QuestionDetector.py
