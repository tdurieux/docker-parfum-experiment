FROM python:3

MAINTAINER Karl Swanson <karlcswanson@gmail.com>

WORKDIR /usr/src/app

RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y --no-install-recommends nodejs && rm -rf /var/lib/apt/lists/*;

COPY . .

RUN pip3 install --no-cache-dir -r py/requirements.txt
RUN npm install --only=prod && npm cache clean --force;
RUN npm run build

EXPOSE 8058

CMD ["python3", "py/micboard.py"]
