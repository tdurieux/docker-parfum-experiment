FROM gui

RUN echo 'export QT_X11_NO_MITSHM=1' >> /home/user/.profile
RUN apt-get install --no-install-recommends -y python-qt4 && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean
RUN sudo -u user mkdir -p /home/user/.config/PyBitmessage/
RUN echo '<application class="Bitmessagemain.py" type="normal"><maximized>yes</maximized><decor>no</decor></application>' > /home/user/.config/openbox/extra-app.xml
COPY PyBitmessage /usr/local/PyBitmessage
