FROM python:3.8

WORKDIR /app
RUN apt-get update && apt-get install --no-install-recommends -y libmagic-dev libfuzzy-dev libfuzzy2 && rm -rf /var/lib/apt/lists/*;
COPY requirements.txt setup.py karton.ini prestart.sh ./
RUN pip install --no-cache-dir .
COPY aurora aurora
COPY tests tests
CMD [ "python", "-m", "pytest" ]