FROM spinlud/python3-selenium-chrome:latest

WORKDIR /app

COPY linkedin_jobs_scraper ./linkedin_jobs_scraper
COPY tests ./tests
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

CMD pytest --capture=no --log-cli-level=INFO
