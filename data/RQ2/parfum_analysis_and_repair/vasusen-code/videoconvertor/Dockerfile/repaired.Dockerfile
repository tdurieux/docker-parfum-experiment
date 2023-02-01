FROM python:3.9.2-slim-buster
RUN mkdir /app && chmod 777 /app
WORKDIR /app
ENV DEBIAN_FRONTEND=noninteractive
RUN apt -qq update && apt -qq --no-install-recommends install -y git ffmpeg && rm -rf /var/lib/apt/lists/*;
COPY . .
RUN pip3 install --no-cache-dir -r requirements.txt
CMD ["bash","convertor.sh"]
