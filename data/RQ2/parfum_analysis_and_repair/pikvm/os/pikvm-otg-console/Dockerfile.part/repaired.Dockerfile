RUN systemctl enable getty@ttyGS0.service

RUN echo ttyGS0 >> /etc/securetty

RUN mkdir /etc/systemd/system/getty@ttyGS0.service.d
COPY stages/pikvm-otg-console/ttyGS0.override /etc/systemd/system/getty@ttyGS0.service.d/override.conf

COPY stages/pikvm-otg-console/kvmd.override /root/kvmd.override
RUN sed -i -e 's/^{}//g' /etc/kvmd/override.yaml \
	&& cat /root/kvmd.override >> /etc/kvmd/override.yaml \
	&& rm /root/kvmd.override