FROM ubuntu:16.04
MAINTAINER cl0und "cl0und@sycl0ver"
RUN apt-get update && apt-get install --no-install-recommends -y vsftpd && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
COPY vsftpd /etc/init.d/vsftpd
RUN chmod 755 /etc/init.d/vsftpd
RUN chown root:root /etc/init.d/vsftpd
RUN useradd -m -d /home/syc10ver -s /bin/bash syc10ver
RUN echo 'syc10ver:Eec5TN9fruOOTp2G' | chpasswd
RUN echo 'root:W8cjifzTASLXBdYf' | chpasswd
RUN echo sctf{Not_0n1y_xx3_but_als0_web_cache}>>/home/syc10ver/flag327a6c4304ad5938eaf0efb6cc3e53dc