FROM python:3

RUN curl -f -sL https://deb.nodesource.com/setup_11.x | bash -
RUN apt-get install --no-install-recommends -y nodejs wget && rm -rf /var/lib/apt/lists/*;

ADD . /app
WORKDIR /app

RUN sh install-adb.sh

RUN npm install && npm cache clean --force;
RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT []
CMD ["python", "main.py", "--server", "http://localhost:4000"]
