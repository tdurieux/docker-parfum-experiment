FROM python:3.8
LABEL maintainer="Tyler Gibbs <gibbstyler7@gmail.com>"

RUN apt-get -y update && apt-get install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y upgrade


ENV IS_DOCKER 1

COPY requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
COPY . /app

EXPOSE 6439
CMD [ "python", "-m", "tsundoku" ]