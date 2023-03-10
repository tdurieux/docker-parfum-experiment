FROM archlinux:latest

RUN pacman -Sy --noconfirm gcc make ruby coin-or-cbc

RUN gem install ruby-cbc

COPY ./cbc_test.rb /cbc_test.rb

CMD ["ruby", "/cbc_test.rb"]