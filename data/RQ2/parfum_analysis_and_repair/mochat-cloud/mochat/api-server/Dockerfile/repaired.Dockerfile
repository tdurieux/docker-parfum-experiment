# @mochat
FROM mochat/mochat:v1

ARG APP_ENV=production
ARG APP_NAME=mochat
ENV APP_ENV=${APP_ENV} \
    APP_NAME=${APP_NAME}

# 项目配置