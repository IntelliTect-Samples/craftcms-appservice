#!/bin/bash

# Print some information for Debugging and visibility
pwd 
echo '-------------------------------------------------------------'
printenv
echo '-------------------------------------------------------------'
echo 'Directory List (root)'
ls -la 
echo '-------------------------------------------------------------'
echo '\n'
echo '-------------------------------------------------------------'
echo 'Directory List (/etc)'
ls -la /etc
echo '-------------------------------------------------------------'
echo '\n'
echo '-------------------------------------------------------------'
echo 'Directory List (/dev)'
ls -la /dev
echo '-------------------------------------------------------------'
echo '\n'

echo 'Bash/Dash Shell Check:'
readlink -f $(which sh)
echo '\n'

echo 'PHP Version Check:'
php -v
echo '\n'

echo 'CraftCMS Install Check:'
php craft install/check
echo '\n'

php -v
echo '\n'

# Copy over environment variables so that they are visible in the Azure Kudu SSH terminal
(printenv | sed -n "s/^\([^=]\+\)=\(.*\)$/export \1=\2/p" | sed 's/"/\\\"/g' | sed '/=/s//="/' | sed 's/$/"/') | sudo tee -a /etc/profile

# ./config.sh

echo "You are login as: `whoami`"

# Start the SSHD service as root and supervisor as appuser
sudo /usr/sbin/sshd &
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisor.conf
