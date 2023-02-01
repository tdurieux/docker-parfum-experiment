FROM python:3.9.1-buster

RUN apt-get update -qq && apt-get -y --no-install-recommends install ffmpeg && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app

COPY . .

RUN pip install --no-cache-dir -U -r requirements.txt

CMD [ "python", "-m", "bot" ]
