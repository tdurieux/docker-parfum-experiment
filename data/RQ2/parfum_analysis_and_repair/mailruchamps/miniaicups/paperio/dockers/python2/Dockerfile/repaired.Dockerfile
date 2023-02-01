FROM stor.highloadcup.ru/aicups/paperio_base
MAINTAINER Boris Kolganov <b.kolganov@corp.mail.ru>

RUN apt-get update && \
    apt-get install --no-install-recommends -y python python-pip && \
    pip install --no-cache-dir numpy scipy keras tensorflow && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

ENV SOLUTION_CODE_ENTRYPOINT=main.py
ENV SOLUTION_CODE_PATH=/opt/client/solution
ENV RUN_COMMAND='python -u $SOLUTION_CODE_PATH/$SOLUTION_CODE_ENTRYPOINT'
