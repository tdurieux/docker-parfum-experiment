# Import Python runtime and set up working directory
FROM python:2.7-slim
WORKDIR /
RUN apt-get update && apt-get install --no-install-recommends -y vim strace xinetd qemu binfmt-support qemu-user-static && rm -rf /var/lib/apt/lists/*;
RUN echo "unimips 41414/tcp" >> /etc/services
ADD unimips.service /etc/xinetd.d/unimips
ADD unimips /unimips
ADD flag /flag

EXPOSE 41414

# Run app.py when the container launches
CMD ["xinetd","-dontfork"]
