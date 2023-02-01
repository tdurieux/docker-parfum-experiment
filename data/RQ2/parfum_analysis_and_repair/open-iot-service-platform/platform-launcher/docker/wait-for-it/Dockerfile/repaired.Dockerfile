FROM debian

RUN apt update && apt install -y --no-install-recommends wait-for-it && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN useradd -ms /bin/bash waituser
USER waituser

ENTRYPOINT ["wait-for-it"]