FROM openrasp/php5.4

MAINTAINER OpenRASP <ext_yunfenxi@baidu.com>

ENV install_url  https://packages.baidu.com/app/thinkphp3.2.3-20180411.tar.gz
ENV install_path /var/www/html

COPY install-package.tar.gz /tmp/

# 下载
RUN cd /tmp \
	&& curl -f "$install_url" -o package.tar.gz \
	&& tar -zxf package.tar.gz -C "$install_path" \
	&& rm -f package.tar.gz \
	&& tar -zxf install-package.tar.gz -C "$install_path" \
	&& rm -f install-package.tar.gz \
	&& chmod 777 -R "$install_path"

# 拷贝数据库文件
COPY database.sql /root/

# 更新启动脚本
COPY start.sh /root/
