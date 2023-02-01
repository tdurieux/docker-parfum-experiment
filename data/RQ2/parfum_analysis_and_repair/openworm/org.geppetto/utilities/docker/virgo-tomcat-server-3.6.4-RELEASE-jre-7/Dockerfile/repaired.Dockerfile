FROM java:7
MAINTAINER Stephen Larson <stephen@openworm.org>
LABEL Description="Virgo Tomcat Server 3.6.4-RELEASE running on Java 7"
RUN apt-get update && apt-get install --no-install-recommends -y curl bsdtar && rm -rf /var/lib/apt/lists/*;
RUN useradd -m virgo
RUN curl -f -L 'https://www.eclipse.org/downloads/download.php?file=/virgo/release/VP/3.6.4.RELEASE/virgo-tomcat-server-3.6.4.RELEASE.zip&mirror_id=580&r=1' | bsdtar --strip-components 1 -C /home/virgo -xzf -

#UNCOMMENT BELOW TO DISABLE ADMIN PAGE & SPLASH SCREEN
#RUN rm /home/virgo/pickup/org.eclipse.virgo.management.console_*.jar
#RUN rm -f /home/virgo/pickup/org.eclipse.virgo.apps.splash_*.jar
#RUN rm -f /home/virgo/pickup/org.eclipse.virgo.apps.splash-*.jar
#RUN rm -f /home/virgo/pickup/org.eclipse.virgo.apps.repository_*.par

EXPOSE 8080
RUN chmod u+x /home/virgo/bin/*.sh
RUN chown -R virgo:virgo /home/virgo
USER virgo

VOLUME /home/virgo

CMD ["/home/virgo/bin/startup.sh"]
