#!/bin/bash
echo "####################################"
echo "###  UPDATE AND INSTALL PROGRAMS ###"
echo "####################################"
SPC_INSTALLED=$(echo $(apt-cache policy jenkins | grep Installed | cut -d ':' -f 2 | cut -d '(' -f 2 | cut -d ')' -f 1 | tr -d ' '))
if [ "$SPC_INSTALLED" == "none" ]; then
  sudo apt-get update
  sudo apt-get install -y software-properties-common
fi

JENKINS_INSTALLED=$(echo $(apt-cache policy jenkins | grep Installed | cut -d ':' -f 2 | cut -d '(' -f 2 | cut -d ')' -f 1 | tr -d ' '))
if [ "$JENKINS_INSTALLED" == "none" ]; then
  wget -q -O - http://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
  sudo add-apt-repository "deb http://pkg.jenkins.io/debian-stable binary/"
  sudo apt-get update
  sudo apt-get install -y jenkins
  JENKINS_DIRECTORY="/home/vagrant/.jenkins"
  mkdir $JENKINS_DIRECTORY
  echo "export JENKINS_HOME=$JENKINS_DIRECTORY" >> /home/vagrant/.profile
  echo $JENKINS_HOME
  echo "export JENKINS_HOME=$JENKINS_DIRECTORY" >> /root/.profile
  sudo echo $JENKINS_HOME
#  sudo /etc/init.d/jenkins start
  sudo /etc/init.d/jenkins status
fi

GIT_INSTALLED=$(echo $(apt-cache policy git | grep Installed | cut -d ':' -f 2 | cut -d '(' -f 2 | cut -d ')' -f 1 | tr -d ' '))
if [ "$GIT_INSTALLED" == "none" ]; then
  sudo apt-get install -y git
fi

MVN_INSTALLED=$(echo $(apt-cache policy maven | grep Installed | cut -d ':' -f 2 | cut -d '(' -f 2 | cut -d ')' -f 1 | tr -d ' '))
if [ "$MVN_INSTALLED" == "none" ]; then
   sudo apt-get install -y maven
fi

sudo mkdir /opt/jdk/
cd /opt/jdk/
JAVA_INSTALLER="jdk-8u66-linux-x64.tar.gz"
JAVA_DOWNLOADED=$(ls -alis | grep $JAVA_INSTALLER)
if [ "$JAVA_DOWNLOADED" == "" ]; then
  wget --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jdk-8u66-linux-x64.tar.gz
  sudo tar -zxf /opt/jdk/jdk-8u66-linux-x64.tar.gz
  sudo update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_66/bin/java 100
  sudo update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_66/bin/javac 100
  #sudo update-alternatives --config java
  #sudo update-alternatives --config javac
fi

