FROM httpd:2.4-alpine

RUN sed -i "s/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/" /usr/local/apache2/conf/httpd.conf;

COPY docker/beerplop.apache.conf /usr/local/apache2/conf/beerplop.apache.conf

RUN echo "Include /usr/local/apache2/conf/beerplop.apache.conf" \
    >> /usr/local/apache2/conf/httpd.conf

# MMAP may cause corrupted js files being delivered
RUN echo "EnableMMAP off" \
    >> /usr/local/apache2/conf/httpd.conf