FROM php:apache  
  
RUN a2enmod rewrite \  
&& docker-php-ext-install mysqli  

