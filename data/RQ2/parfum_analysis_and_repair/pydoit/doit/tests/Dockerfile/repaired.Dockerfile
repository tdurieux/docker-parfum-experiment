# Run/test doit on debian unstable

# docker build -t doit-debian .
# docker run -it --cap-add SYS_PTRACE -v /home/eduardo/work/doit/dev:/root/doit doit-debian

# pip3 install -e .
# pip3 install -r dev_requirements.txt


from debian:unstable

RUN apt-get update && apt-get install eatmydata --no-install-recommends -y && rm -rf /var/lib/apt/lists/*;
RUN eatmydata apt-get install python3-pytest python3-pip -y
RUN apt-get install --no-install-recommends python3-gdbm strace -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /root/doit
