# Vaccom -  phần mềm hỗ trợ quản lý và tổ chức điểm tiêm chủng Vaccine
#     Copyright (C) 2021 Vaccom Development team

#     This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU Affero General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.

#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU Affero General Public License for more details.

#     You should have received a copy of the GNU Affero General Public License
#     along with this program.  If not, see <https://www.gnu.org/licenses/>.

FROM nginx

RUN apt-get update -y && apt-get install cron openssh-server sshpass -y

COPY docker-entrypoint.sh /docker-entrypoint.sh

COPY templates/default.conf /opt/

RUN chmod +x /docker-entrypoint.sh