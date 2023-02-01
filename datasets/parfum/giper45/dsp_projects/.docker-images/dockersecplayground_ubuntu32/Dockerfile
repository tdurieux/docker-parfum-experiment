FROM m0elnx/ubuntu-32bit

RUN apt-get update && apt-get install -y vim gcc make nano build-essential gdb

COPY adduser.sh /adduser.sh
COPY setgw.sh /setgw.sh
COPY addctf.sh /addctf.sh
COPY exec.sh /exec.sh
COPY start_telnet.sh /start_telnet.sh
COPY disable_aslr.sh /disable_aslr.sh
COPY disable_compiler_protection.sh /disable_compiler_protection.sh

RUN apt-get install -y xinetd telnetd
RUN echo ' service telnet \n\
{\n\
        disable                 = no \n\
        socket_type             = stream\n\
        wait                    = no\n\
        user                    = root\n\
        server                  = /usr/sbin/in.telnetd\n\
        log_on_failure          += HOST\n\
}\n' \
>> /etc/xinetd.d/telnet

LABEL \
      type="host" \
      caps_add="ALL" \
      privileged=true \
      actions.exec.command="/exec.sh " \ 
      actions.exec.description="Execute a command in the container" \ 
      actions.exec.args.command.val="mkdir hello" \
      actions.exec.args.command.type="text" \

      actions.adduser.command="/adduser.sh" \ 
      actions.adduser.description="Add a new username : <name> <password> " \ 
      actions.adduser.args.name.val="user" \
      actions.adduser.args.name.type="text" \
      actions.adduser.args.name.rule.pattern="^[a-zA-Z0-9_-]+$" \
      actions.adduser.args.password.val="password" \
      actions.adduser.args.password.type="text" \
      actions.adduser.args.password.rule.pattern="^[a-zA-Z0-9_-]+$" \

      actions.addctf.command="/addctf.sh" \ 
      actions.addctf.description="Add a ctf in /home/<username> directory inside a secret file" \ 
      actions.addctf.args.username.val="" \
      actions.addctf.args.username.type="text" \
      actions.addctf.args.username.rule.pattern="^[a-zA-Z0-9_-]+$" \
      actions.addctf.args.ctf.val="" \
      actions.addctf.args.ctf.type="text" \

      actions.disable_aslr.command="/disable_aslr.sh" \ 
      actions.disable_aslr.description="Disable aslr from this container" \ 

      actions.disable_compiler_protection.command="/disable_compiler_protection.sh" \ 
      actions.disable_compiler_protection.description="Disable compiler protection from this container and make stack executable" \ 

      actions.start_telnet.command="/start_telnet.sh" \
      actions.start_telnet.description="Start a telnet server" \
