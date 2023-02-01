FROM ubuntu:14.04  
MAINTAINER Tomohisa Kusano <siomiz@gmail.com>/Demoshow <ADD CN_FONT>  
  
ENV CHROME_REMOTE_DESKTOP_DEFAULT_DESKTOP_SIZES 1024x768  
  
COPY copyables /  
  
ADD https://dl.google.com/linux/linux_signing_key.pub /tmp/  
  
RUN apt-key add /tmp/linux_signing_key.pub \  
&& apt-get update \  
&& apt-get install -y \  
google-chrome-stable \  
chrome-remote-desktop \  
ttf-wqy-microhei\  
pulseaudio \  
supervisor \  
x11vnc \  
&& apt-get clean \  
&& rm -rf /var/cache/* /var/log/apt/* /tmp/* \  
&& addgroup chrome-remote-desktop \  
&& useradd -m -G chrome-remote-desktop,pulse-access chrome \  
&& ln -s /crdonly /usr/local/sbin/crdonly \  
&& ln -s /update /usr/local/sbin/update \  
&& ln -s /update /etc/cron.hourly/update \  
&& mkdir -p /home/chrome/.config/chrome-remote-desktop \  
&& chown -R chrome:chrome /home/chrome/.config  
  
VOLUME ["/home/chrome"]  
  
EXPOSE 5900  
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]  

