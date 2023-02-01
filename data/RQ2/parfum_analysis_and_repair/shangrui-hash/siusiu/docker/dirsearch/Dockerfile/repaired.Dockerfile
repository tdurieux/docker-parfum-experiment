FROM kalilinux/kali-rolling:latest
# RUN echo "#阿里云\ndeb http://mirrors.aliyun.com/kali kali-rolling main non-free contrib\n deb-src http://mirrors.aliyun.com/kali kali-rolling main non-free contrib\n #清华大学\n deb http://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free\ndeb-src https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free\n #浙江大学\n deb http://mirrors.zju.edu.cn/kali kali-rolling main contrib non-free\n deb-src http://mirrors.zju.edu.cn/kali kali-rolling main contrib non-free " > /etc/apt/sources.list \
RUN apt-get update \
&& apt-get install --no-install-recommends -y dirsearch && rm -rf /var/lib/apt/lists/*;
COPY ./dir.txt  /dir.txt
ENTRYPOINT [ "dirsearch","--full-url","--random-agent","-w","/dir.txt"]
