FROM python:3

COPY . /scraper
RUN pip install --no-cache-dir -r /scraper/requirements.txt
