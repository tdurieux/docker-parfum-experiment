FROM kyyex/kyy-userbot:busterv2
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    curl \
    git \
    ffmpeg && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    npm i -g npm && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;
RUN git clone -b Kyy-Userbot https://github.com/muhammadrizky16/Kyy-Userbot /home/Kyy-Userbot/ \
    && chmod 777 /home/Kyy-Userbot \
    && mkdir /home/Kyy-Userbot/bin/
WORKDIR /home/Kyy-Userbot/
COPY ./sample_config.env ./config.env* /home/Kyy-Userbot/
RUN pip install --no-cache-dir -r requirements.txt
CMD ["python3", "-m", "userbot"]
