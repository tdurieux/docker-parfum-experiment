FROM villarrealized/debian-pygame-base
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
COPY requirements.txt /usr/src/app
WORKDIR /usr/src/app
RUN pip install --no-cache-dir -r requirements.txt
COPY . /usr/src/app

CMD [ "python", "main.py"]
