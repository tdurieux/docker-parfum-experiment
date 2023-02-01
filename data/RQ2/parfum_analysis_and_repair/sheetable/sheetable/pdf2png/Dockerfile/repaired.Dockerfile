FROM python:3.8-slim-buster

WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends poppler-utils -y && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir flask pdf2image

COPY . .

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]