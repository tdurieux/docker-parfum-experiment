FROM swift

ENV TZ: Asia/Tokyo

RUN apt-get update \
    && apt-get install --no-install-recommends -y language-pack-ja-base language-pack-ja \
    time \
    binutils && rm -rf /var/lib/apt/lists/*;

ENV LANG=ja_JP.UTF-8
