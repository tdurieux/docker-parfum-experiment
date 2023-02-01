FROM python:3.8-slim-buster
RUN mkdir /pdf && chmod 777 /pdf

WORKDIR /pdf

COPY dockerImage.txt dockerImage.txt
RUN pip3 install --no-cache-dir -r dockerImage.txt

RUN apt update && apt install --no-install-recommends -y ocrmypdf && rm -rf /var/lib/apt/lists/*;

COPY . .

CMD python3 pdf.py
