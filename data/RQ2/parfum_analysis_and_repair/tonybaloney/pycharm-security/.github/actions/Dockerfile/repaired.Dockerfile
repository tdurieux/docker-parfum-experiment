FROM anthonypjshaw/pycharm-security:latest
COPY action.sh /action.sh
COPY parse.py /code/parse.py
COPY project.iml /code/project.iml
COPY jdk.table.xml /root/.config/JetBrains/PyCharm2021.3/jdk.table.xml
RUN apt-get -y update && apt-get -y --no-install-recommends install python3 python3-pip python3-venv && python3 -m pip install setuptools && rm -rf /var/lib/apt/lists/*;
RUN ["chmod", "+x", "/action.sh"]
ENTRYPOINT ["/action.sh"]
