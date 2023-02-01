FROM ubuntu:16.04
RUN apt-get -y update && apt-get install --no-install-recommends -y python2.7 make libc6-dev g++ zlib1g-dev build-essential git libx11-dev xutils-dev zlib1g-dev python-pip bowtie2 samtools && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir scipy
RUN pip install --no-cache-dir git+https://github.com/katholt/srst2
