FROM nginx:1.16
RUN apt-get update && \
  apt-get install --no-install-recommends -y apt-utils \
  locales && \
  echo "ja_JP.UTF-8 UTF-8" > /etc/locale.gen && \
  locale-gen ja_JP.UTF-8 && rm -rf /var/lib/apt/lists/*;
ENV LC_ALL ja_JP.UTF-8
# 初期状態の設定ファイル
ADD ./docker/nginx/nginx.conf /etc/nginx/nginx.conf
ADD ./docker/nginx/default.conf /etc/nginx/conf.d/default.conf