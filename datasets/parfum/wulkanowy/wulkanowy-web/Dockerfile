FROM nikolaik/python-nodejs:python3.10-nodejs16-bullseye

ENV PYTHONUNBUFFERED 1

WORKDIR /src/frontend

COPY frontend/package-lock.json /src/frontend/package-lock.json
COPY frontend/package.json /src/frontend/package.json

RUN npm install

WORKDIR /src/backend

COPY backend/requirements.txt .
RUN pip install -r requirements.txt

COPY frontend/* ./frontend/
COPY frontend/src/* ./frontend/src/
COPY frontend/public/* ./frontend/public/
COPY frontend/tests/* ./frontend/tests/
COPY backend/* ./backend/
COPY backend/app/* ./backend/app/
COPY backend/app/endpoints/* ./backend/app/endpoints/
COPY backend/app/models/* ./backend/app/models/

WORKDIR /src/frontend
EXPOSE 8000

ENTRYPOINT [ "python3", "main", "0.0.0.0:8000"]