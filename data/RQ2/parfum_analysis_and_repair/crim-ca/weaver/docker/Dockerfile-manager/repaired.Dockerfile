FROM weaver:base
LABEL description.short="Weaver Manager"

CMD pserve "${APP_CONFIG_DIR}/weaver.ini"