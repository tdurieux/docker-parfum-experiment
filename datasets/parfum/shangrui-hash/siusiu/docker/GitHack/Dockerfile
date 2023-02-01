FROM python:2.7.18-alpine
WORKDIR /root
RUN apk add git \ 
&& git clone --depth 1 https://github.com/lijiejie/GitHack.git

ENTRYPOINT ["python","/root/GitHack/GitHack.py"]
CMD []
