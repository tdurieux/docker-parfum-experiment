#
# PHP 7.4 with JIT compilation support(Dynasm)
#

FROM dmitrybalabka/php-jit:latest-7.4
WORKDIR /app
ADD . /app
# Settings for network better performance
# see http://yandextank.readthedocs.io/en/latest/generator_tuning.html#tuning