FROM python:3.8

RUN pip install fastapi uvicorn 
COPY ./backend/ /backend/
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt