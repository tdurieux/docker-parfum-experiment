FROM ubuntu:18.04
COPY . /app
WORKDIR /app
RUN apt-get update
RUN apt-get install --no-install-recommends build-essential -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python3.6 -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python3.6-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN mkdir /.cache
RUN chmod 777 /.cache
RUN pip3 install --no-cache-dir -r requirements.txt
ENTRYPOINT python3 ReadingComp.py
