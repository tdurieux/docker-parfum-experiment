FROM mariadb:10.2.40

ARG GITHUB_ORG
ARG OH_CORE_BRANCH

ENV MYSQL_DATABASE=oh
ENV MYSQL_ROOT_PASSWORD=root
ENV MYSQL_USER=isf
ENV MYSQL_PASSWORD=isf123

RUN apt-get update && apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
RUN git clone --depth=1 -b ${OH_CORE_BRANCH} https://github.com/${GITHUB_ORG}/openhospital-core.git
WORKDIR /openhospital-core

EXPOSE 3306

RUN cp sql/step_01_create_structure.sql /docker-entrypoint-initdb.d/
RUN cp sql/step_02_dump_menu.sql /docker-entrypoint-initdb.d/
RUN cp sql/step_03_dump_default_data_en.sql /docker-entrypoint-initdb.d/
#RUN cp sql/step_04_all_following_steps.sql /docker-entrypoint-initdb.d/
RUN cp sql/step_05_update_menu_i18n.sql /docker-entrypoint-initdb.d/
RUN cp sql/step_06_opd_extended.sql /docker-entrypoint-initdb.d/
RUN cp sql/step_07_modifiche_matiri.sql /docker-entrypoint-initdb.d/
RUN cp sql/step_08_int_restore_del_labrestype.sql /docker-entrypoint-initdb.d/
RUN cp sql/step_09_update_agetype.sql /docker-entrypoint-initdb.d/
RUN cp sql/step_1* /docker-entrypoint-initdb.d/
RUN cp sql/step_2* /docker-entrypoint-initdb.d/
RUN cp sql/step_3* /docker-entrypoint-initdb.d/
RUN cp sql/step_4* /docker-entrypoint-initdb.d/
RUN cp sql/step_5* /docker-entrypoint-initdb.d/
RUN cp sql/step_6* /docker-entrypoint-initdb.d/
RUN cp sql/step_7* /docker-entrypoint-initdb.d/
RUN mkdir data_en
RUN cp sql/data_en/* data_en/