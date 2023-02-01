FROM arm32v7/python:3.9-slim
RUN apt update && apt install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
ADD requirements.txt /
RUN pip install --no-cache-dir -r requirements.txt
