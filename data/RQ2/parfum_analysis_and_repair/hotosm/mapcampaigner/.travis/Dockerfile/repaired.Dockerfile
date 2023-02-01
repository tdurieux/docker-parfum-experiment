FROM amazonlinux
RUN amazon-linux-extras install -y python3 && \
    pip3 install --no-cache-dir --user && \
    pip3 install --no-cache-dir --upgrade pip
CMD ["pip3", "install", "-r", "requirements.txt", "-t", "/dependencies"]


