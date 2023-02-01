FROM python:3.6

# Create app directory
WORKDIR /app

# Install app dependencies
COPY ./requirements.txt ./

RUN pip3 install --no-cache-dir flask && pip3 install --no-cache-dir gunicorn

RUN apt-get update && apt-get install --no-install-recommends -y sox libsox-fmt-mp3 && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -r requirements.txt

# Bundle app source
COPY . /app

EXPOSE 5000
CMD [ "python", "app.py" ]
