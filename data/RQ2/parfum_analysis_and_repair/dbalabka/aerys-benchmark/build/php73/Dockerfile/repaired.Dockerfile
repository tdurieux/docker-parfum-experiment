#
# Latest PHP 7.3.*
#

FROM php:7.3-cli
WORKDIR /app
ADD . /app
# Settings for network better performance
# see http://yandextank.readthedocs.io/en/latest/generator_tuning.html#tuning