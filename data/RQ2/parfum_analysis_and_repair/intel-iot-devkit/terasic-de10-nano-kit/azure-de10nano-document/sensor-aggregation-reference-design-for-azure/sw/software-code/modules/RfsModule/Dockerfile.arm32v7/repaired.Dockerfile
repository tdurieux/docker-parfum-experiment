# Copyright (C) 2021 Intel Corporation
# Licensed under the MIT license. See LICENSE file in the project root for
# full license information.

FROM arm32v7/python:3.7-buster as builder

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

FROM arm32v7/python:3.7-slim-buster

WORKDIR /app

COPY --from=builder /usr/local/lib/python3.7/site-packages /usr/local/lib/python3.7/site-packages

COPY ./package ./package
COPY ./main.py .
#Not Overlay
#CMD [ "python3", "-u", "./main.py" ]

#Overlay Files
COPY ./overlay/Module5_Sample_HW.rbf .
COPY ./overlay/rfs-overlay.dtbo .
COPY ./overlay/overlay.sh .
COPY ./overlay/run.sh .
RUN chmod +x overlay.sh
RUN chmod +x run.sh

CMD [ "/app/run.sh"]