FROM 10.10.10.94:5000/tensorflow:0.9.0-gpu

COPY sources.list /etc/apt
RUN apt-get update && apt-get install --no-install-recommends -y vim git && rm -rf /var/lib/apt/lists/*;
WORKDIR /tmp
RUN curl -f https://j.mp/spf13-vim3 -L > spf13-vim.sh && sh spf13-vim.sh

