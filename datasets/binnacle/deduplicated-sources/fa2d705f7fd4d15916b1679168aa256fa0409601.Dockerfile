FROM phundament/app:4.0.2

RUN composer require \
    yiisoft/yii2-apidoc:dev-master \
    schmunk42/yii2-apidoc-template:dev-master