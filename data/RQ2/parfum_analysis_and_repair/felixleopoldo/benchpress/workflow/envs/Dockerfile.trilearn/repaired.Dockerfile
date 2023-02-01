FROM onceltuca/trilearn:1.23

RUN apt install -y --no-install-recommends time && rm -rf /var/lib/apt/lists/*;