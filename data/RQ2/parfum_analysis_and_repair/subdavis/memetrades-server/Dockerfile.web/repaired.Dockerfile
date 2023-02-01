FROM python:2
ENV PYTHONUNBUFFERED 1 

EXPOSE 80
EXPOSE 443

RUN apt update && apt install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;

RUN mkdir /src
WORKDIR /src
ADD . /src

RUN pip install --no-cache-dir -r requirements.txt

RUN ln -s /src/nginx-memes.conf /etc/nginx/sites-enabled/memes.conf
RUN chmod +X /src/web-startup.sh

CMD ["/bin/bash", "/src/web-startup.sh"]