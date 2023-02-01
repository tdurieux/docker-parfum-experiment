#
# PHP 8-preview with JIT compilation support(Dynasm)
#

FROM dmitrybalabka/php-jit:latest
WORKDIR /app
ADD . /app
# Settings for network better performance
# see http://yandextank.readthedocs.io/en/latest/generator_tuning.html#tuning