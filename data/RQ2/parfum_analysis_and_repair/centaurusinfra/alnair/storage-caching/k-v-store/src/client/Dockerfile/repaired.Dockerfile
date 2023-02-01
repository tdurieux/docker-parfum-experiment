FROM ubuntu:20.04
RUN apt update && apt install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN mkdir app
WORKDIR /app
COPY client ./
COPY grpctool ./grpctool
RUN pip3 install --no-cache-dir -r requirements.txt
RUN chmod +x *
RUN apt update && apt install --no-install-recommends -y nano nvidia-utils-460 && rm -rf /var/lib/apt/lists/*;
CMD [ "python3", "client.py" ]