FROM python:3.6
ENV PYTHONUNBUFFERED 1
RUN mkdir /code
WORKDIR /code
ADD requirements.txt /code/
RUN pip install -r requirements.txt
RUN apt-get install default-libmysqlclient-dev
ADD . /code/
RUN cp temp/patch_for_reversion_compare.py /usr/local/lib/python3.6/site-packages/reversion_compare/views.py
RUN cp temp/board_base.html /usr/local/lib/python3.6/site-packages/machina/templates/machina/board_base.html

RUN cp temp/notifications/models.py /usr/local/lib/python3.6/site-packages/notifications/models.py
RUN cp temp/notifications/urls.py /usr/local/lib/python3.6/site-packages/notifications/urls.py
RUN cp temp/notifications/views.py /usr/local/lib/python3.6/site-packages/notifications/views.py
RUN cp temp/notifications/notifications_tags.py /usr/local/lib/python3.6/site-packages/notifications/templatetags/notifications_tags.py
RUN cp temp/notifications/list.html /usr/local/lib/python3.6/site-packages/notifications/templates/notifications/list.html
RUN cp temp/notifications/settings.py /usr/local/lib/python3.6/site-packages/notifications/settings.py

RUN cp temp/base_wiki.html /usr/local/lib/python3.6/site-packages/wiki/templates/wiki/base.html
RUN cp temp/article_menu_wiki.html /usr/local/lib/python3.6/site-packages/wiki/templates/wiki/includes/article_menu.html
RUN cp temp/article_wiki.html /usr/local/lib/python3.6/site-packages/wiki/templates/wiki/article.html
RUN cp temp/forum_views.py /usr/local/lib/python3.6/site-packages/machina/apps/forum/views.py
RUN cp .env.docker .env
