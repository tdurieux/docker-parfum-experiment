FROM python:3.8

RUN pip install --no-cache-dir fastapi uvicorn
COPY ./backend/ /backend/
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt