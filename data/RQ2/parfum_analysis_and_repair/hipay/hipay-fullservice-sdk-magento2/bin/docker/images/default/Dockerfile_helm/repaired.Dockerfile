FROM bitnami/magento:2.4.4

RUN apt-get update && apt-get install --no-install-recommends -y git unzip && rm -rf /var/lib/apt/lists/*;

RUN curl -f -O  https://files.magerun.net/n98-magerun2.phar \
    && chmod +x ./n98-magerun2.phar \
    && cp ./n98-magerun2.phar /usr/local/bin/ \
    && rm ./n98-magerun2.phar

#====================================================
# OVERRIDE PARENT ENTRYPOINT
#=====================================================

ENV DIRPATH=/bitnami/magento

RUN echo "is_app_initialized() { false; }" >> /opt/bitnami/scripts/libpersistence.sh

COPY ./bin/docker/conf/development/auth.json /usr/sbin/.composer/auth.json
COPY ./bin/docker/conf/development/auth.json $DIRPATH/var/composer_home/auth.json
RUN chown -R daemon: /usr/sbin/.composer/ $DIRPATH/var/composer_home

COPY ./Block $DIRPATH/app/code/HiPay/FullserviceMagento/Block
COPY ./Controller $DIRPATH/app/code/HiPay/FullserviceMagento/Controller
COPY ./etc $DIRPATH/app/code/HiPay/FullserviceMagento/etc
COPY ./Helper $DIRPATH/app/code/HiPay/FullserviceMagento/Helper
COPY ./Model $DIRPATH/app/code/HiPay/FullserviceMagento/Model
COPY ./Console $DIRPATH/app/code/HiPay/FullserviceMagento/Console
COPY ./Observer $DIRPATH/app/code/HiPay/FullserviceMagento/Observer
COPY ./Plugin $DIRPATH/app/code/HiPay/FullserviceMagento/Plugin
COPY ./Ui $DIRPATH/app/code/HiPay/FullserviceMagento/Ui
COPY ./view $DIRPATH/app/code/HiPay/FullserviceMagento/view
COPY ./Setup $DIRPATH/app/code/HiPay/FullserviceMagento/Setup
COPY ./Cron $DIRPATH/app/code/HiPay/FullserviceMagento/Cron
COPY ./i18n $DIRPATH/app/code/HiPay/FullserviceMagento/i18n
COPY ./Logger $DIRPATH/app/code/HiPay/FullserviceMagento/Logger
COPY ./Test $DIRPATH/app/code/HiPay/FullserviceMagento/Test
COPY ./composer.json $DIRPATH/app/code/HiPay/FullserviceMagento/composer.json
COPY ./registration.php $DIRPATH/app/code/HiPay/FullserviceMagento/registration.php

COPY ./bin/docker/images/default/entrypoint.sh /usr/local/bin/
RUN  chmod u+x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD [ "/opt/bitnami/scripts/magento/run.sh" ]
