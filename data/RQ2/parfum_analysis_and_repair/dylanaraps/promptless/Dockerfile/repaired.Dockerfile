FROM archlinux/base:latest

# The secure way
RUN cd && curl -f "https://raw.githubusercontent.com/dylanaraps/promptless/master/install.sh" | sh && mv .profile .bashrc

CMD bash
