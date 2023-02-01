FROM python:3.9

RUN apt-get update && apt-get upgrade -y
RUN apt install --no-install-recommends tor -y && rm -rf /var/lib/apt/lists/*;
RUN mkdir /executables
COPY listener/ ./listener
COPY client/ ./client
RUN pip install --no-cache-dir -r listener/requirements.txt
CMD [ "python", "./listener/listener.py", "8843", "8843" ]