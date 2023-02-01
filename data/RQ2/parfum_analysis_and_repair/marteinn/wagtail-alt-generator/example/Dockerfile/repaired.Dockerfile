FROM python:3.6

RUN apt-get update && apt-get install --no-install-recommends -y \
    netcat \
    libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python-tk \
    binutils libproj-dev && rm -rf /var/lib/apt/lists/*;

ENV PYTHONUNBUFFERED 1
ENV APP_LOG_DIR /var/log/app

ADD . /app/
WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt

# Install and setup vim
RUN apt-get update && apt-get install --no-install-recommends -y vim curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -L https://raw.githubusercontent.com/marteinn/Notebook/master/vim/vim-server-conf.vimrc > ~/.vimrc

EXPOSE 8080

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["runserver"]
