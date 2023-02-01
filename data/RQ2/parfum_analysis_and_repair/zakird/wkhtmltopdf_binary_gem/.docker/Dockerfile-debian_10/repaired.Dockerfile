FROM debian:10

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y ruby libjpeg62-turbo libpng16-16 libxrender1 libfontconfig1 libxext6 && rm -rf /var/lib/apt/lists/*;

CMD /root/wkhtmltopdf_binary_gem/bin/wkhtmltopdf --version
