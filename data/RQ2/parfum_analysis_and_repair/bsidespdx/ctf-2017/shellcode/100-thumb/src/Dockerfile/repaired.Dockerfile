# Import Python runtime and set up working directory
FROM python:2.7-slim
WORKDIR /
RUN apt-get update && apt-get install --no-install-recommends -y vim strace xinetd qemu binfmt-support qemu-user-static && rm -rf /var/lib/apt/lists/*;
RUN echo "thumb 31337/tcp" >> /etc/services
ADD thumb.service /etc/xinetd.d/thumb
ADD thumb /thumb
ADD flag /flag

EXPOSE 31337

# Run app.py when the container launches
CMD ["xinetd","-dontfork"]
