FROM python:3

WORKDIR /usr/src/app

RUN apt-get update -y && apt-get install --no-install-recommends firefox-esr -y && rm -rf /var/lib/apt/lists/*;

RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.31.0/geckodriver-v0.31.0-linux32.tar.gz

RUN tar -xf geckodriver-v0.31.0-linux32.tar.gz && rm geckodriver-v0.31.0-linux32.tar.gz

RUN rm geckodriver-v0.31.0-linux32.tar.gz

RUN mv geckodriver /usr/bin/

ADD ./ ./

RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python", "./anibot.py", "--configfile", "/config/ani.json", "--docker" ]