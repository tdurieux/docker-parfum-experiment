FROM python:3.9.7-slim-buster
RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends git curl python3-pip ffmpeg -y && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm i -g npm && npm cache clean --force;
WORKDIR /app
COPY . /app
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -U -r requirements.txt
CMD python3 -m vcbot