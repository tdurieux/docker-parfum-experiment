FROM python:3.9.7
RUN apt-get update && apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
COPY . .
RUN pip3 install --no-cache-dir -U pip && pip3 install --no-cache-dir -r requirements.txt
CMD python3 -m bot
