#!/usr/bin/env bash

# Configuring
CONF_vagrant_dir="/var/env"
source ${CONF_vagrant_dir}/provision_private_config.sh




# LETS GO...


mkayTitle "Configuring Locale..."
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
sudo dpkg-reconfigure -f noninteractive locales
mkay "done."




mkayTitle "Update packages..."
sudo apt-get -y update
sudo apt-get -y upgrade
mkay "done."




mkayTitle "Installing default apps..."
sudo apt-get -y install git curl vim htop mc pv
# sudo apt-get -y install ngrok
# sudo apt-get -y install nodejs npm subversion
# sudo apt-get -y install unixodbc memcached sendmail
# sudo apt-get -y install rabbitmq-server redis-server
sudo apt-get -y install python-software-properties software-properties-common
mkay "done."




mkayTitle "Installing Java (JDK)..."
sudo apt-get -y install default-jdk
mkay "done."




mkayTitle "Creating Tomcat user..."
sudo groupadd tomcat
sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
mkay "done."




mkayTitle "Install Tomcat..."
cd /tmp
wget http://www-us.apache.org/dist/tomcat/tomcat-9/v9.0.26/bin/apache-tomcat-9.0.26.tar.gz
tar xzf apache-tomcat-9.0.26.tar.gz
sudo mv apache-tomcat-9.0.26 /usr/local/apache-tomcat9
mkay "done."





mkayTitle "Configure env vars..."
echo "export CATALINA_HOME="/usr/local/apache-tomcat9"" >> ~/.bashrc
echo "export JAVA_HOME="/usr/lib/jvm/java-11-oracle"" >> ~/.bashrc
echo "export JRE_HOME="/usr/lib/jvm/java-11-oracle"" >> ~/.bashrc
source ~/.bashrc

sed -i '/<\/tomcat-users>/ i\<role rolename="manager-gui" />' /usr/local/apache-tomcat9/conf/tomcat-users.xml
sed -i '/<\/tomcat-users>/ i\<user username="manager" password="manager" roles="manager-gui" />' /usr/local/apache-tomcat9/conf/tomcat-users.xml
sed -i '/<\/tomcat-users>/ i\<role rolename="admin-gui" />' /usr/local/apache-tomcat9/conf/tomcat-users.xml
sed -i '/<\/tomcat-users>/ i\<user username="admin" password="admin" roles="manager-gui,admin-gui" />' /usr/local/apache-tomcat9/conf/tomcat-users.xml

sed 's/0:0:1/0:0:1|^.*$/g' /usr/local/apache-tomcat9/webapps/manager/META-INF/context.xml | tee /usr/local/apache-tomcat9/webapps/manager/META-INF/context.xml
sed 's/0:0:1/0:0:1|^.*$/g' /usr/local/apache-tomcat9/webapps/host-manager/META-INF/context.xml | tee /usr/local/apache-tomcat9/webapps/host-manager/META-INF/context.xml

cp /usr/local/apache-tomcat9/conf/server.xml /usr/local/apache-tomcat9/conf/server_back.xml
sed 's/\"8080\"/\"80\"/g' /usr/local/apache-tomcat9/conf/server.xml | tee /usr/local/apache-tomcat9/conf/server.xml

cd /usr/local/apache-tomcat9
chmod +x ./bin/startup.sh
/usr/local/apache-tomcat9/bin/startup.sh
mkay "done."




mkayTitle "Installation is done."
mkay "Available sites on IP: http://192.168.161.55/"
for site in ${HOSTS_ARRAY[@]}; do
    mkay " - http://${site}/"
done




