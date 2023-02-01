FROM python:3.7-slim
RUN apt-get update
RUN apt-get -y --no-install-recommends install python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y locales locales-all && rm -rf /var/lib/apt/lists/*;
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
COPY / /app
WORKDIR /app
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -r src/requirements.txt
CMD ["python3", "/app/src/app.py"]
