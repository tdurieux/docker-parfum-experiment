FROM python:3.5-slim
RUN apt-get update && apt-get install --no-install-recommends pandoc -y && rm -rf /var/lib/apt/lists/*;
COPY . /nsx2md
WORKDIR nsx2md
ENTRYPOINT [ "python", "./nsx2md.py" ] 
