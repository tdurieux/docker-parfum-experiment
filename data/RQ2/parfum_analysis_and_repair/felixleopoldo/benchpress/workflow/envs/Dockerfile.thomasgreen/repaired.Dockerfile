FROM onceltuca/thomasgreen:1.19

RUN apt install -y --no-install-recommends time && rm -rf /var/lib/apt/lists/*;