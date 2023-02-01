FROM debian

RUN apt-get update && apt-get install --no-install-recommends -y libasound2 libgtk-3-0 && rm -rf /var/lib/apt/lists/*;

COPY aicup2019 aicup2019