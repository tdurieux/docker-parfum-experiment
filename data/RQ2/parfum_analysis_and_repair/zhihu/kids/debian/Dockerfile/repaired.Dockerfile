FROM zhihu/kids

RUN apt-get update && apt-get install --no-install-recommends -yq ruby-dev && rm -rf /var/lib/apt/lists/*;
RUN gem install fpm

WORKDIR /kids

COPY kids.conf /kids/debian/kids.conf
RUN cd /kids/debian && ./make_deb.sh

VOLUME ["/deb"]

CMD ["bash", "-c", "cp /kids/debian/*.deb /deb"]
