FROM python:3.10

RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends ffmpeg -y && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm i -g npm && npm cache clean --force;

RUN mkdir /app/
COPY . /app
WORKDIR /app

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -U -r requirements.txt

CMD python3 Mq.py
