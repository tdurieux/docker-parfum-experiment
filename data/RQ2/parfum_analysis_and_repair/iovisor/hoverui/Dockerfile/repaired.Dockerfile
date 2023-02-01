FROM httpd:2.4
COPY ./css/ /usr/local/apache2/htdocs/css/
COPY ./js/ /usr/local/apache2/htdocs/js/
COPY ./img/ /usr/local/apache2/htdocs/img/
COPY ./index.html /usr/local/apache2/htdocs/