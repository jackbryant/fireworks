/etc/init.d/fireworks.sh start

alias fwstop='/etc/init.d/fireworks.sh stop'
alias fwstart='/etc/init.d/fireworks.sh start'
alias fwstatus='/etc/init.d/fireworks.sh status'
alias fw='/etc/init.d/fireworks.sh restart'

# Increase volume by 10%
alias volu='sudo amixer set PCM -- $[$(amixer get PCM|grep -o [0-9]*%|sed 's/%//')+10]%'
# Decrease volume by 10%
alias vold='sudo amixer set PCM -- $[$(amixer get PCM|grep -o [0-9]*%|sed 's/%//')-10]%'
