#! /bin/bash
echo "Provisioning script $0"

echo "Install needed packages"
dnf -y install postfix
dnf -y install s-nail
dnf -y install dovecot telnet

echo "Copy configuration files"
#cp -R /vagrant/provision/server/mail/etc/* /etc

echo "Configure firewall"
firewall-cmd -- add-service=smtp -- permanent
firewall-cmd -- add-service=pop3 -- permanent
firewall-cmd -- add-service=pop3s -- permanent
firewall-cmd -- add-service=imap -- permaneiit
firewall-cmd -- add-service=imaps -- permanent
firewall-cmd -- reload

restorecon -vR /etc

echo "Start postfix service"
systemctl enable postfix
systemctl start postfix

echo "Configure postfix"
postconf -e 'mydomain = user. net'
postconf -e 'myorigin = $mydomain'
postconf -e 'inet_protocols = ipv4'
postconf -e 'inet_interfaces = all'
postconf -e 'mydestination = $myhostname, localhost. $mydomain, localhost, $mydomain'
postconf -e 'mynetworks = 127.0.0.0/8, 192.168.0.0/16'
postconf -e 'home_mailbox = Maildir/'

postfix set-permissions

restorecon -vR /etc
systemctl stop postfix
systemctl start postfix
systemctl stop dovecot
systemctl start dovecot