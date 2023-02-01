FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y \
        apache2 \
        apache2-dev \
        build-essential \
        libcurl4-openssl-dev \
        libjansson-dev \
        libssl-dev \
        vim \
        git \
        pkg-config \
        silversearcher-ag && rm -rf /var/lib/apt/lists/*;

WORKDIR tmp
RUN git clone https://github.com/PerimeterX/mod_perimeterx.git
RUN cd mod_perimeterx && make

COPY perimeterx.conf /etc/apache2/mods-available/perimeterx.conf
RUN ln -s /etc/apache2/mods-available/perimeterx.conf /etc/apache2/mods-enabled/perimeterx.conf

# Log to debug level
RUN sed -i -e 's/LogLevel warn/LogLevel debug/' /etc/apache2/apache2.conf

COPY index.html /var/www/html/
EXPOSE 80

CMD ["bash"]
