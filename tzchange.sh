#!/bin/bash
############################################################
#Yazar: Kursad Cokyaman
#Amac: Bu script Turkiye 2015 DST degisikligi sebebiyle 
#RHEL/Oracle Linux/CentOS OS 'lerinde gerekli guncellemeleri
#yaparak degisikligi aktif eder.
############################################################


###
#Renkler
###
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

###
#While dongusu
###
for srv in `cat $1`
do

###
#tzdata Update
###
  ver=`ssh $srv 'rpm -qf /etc/redhat-release'`
  if [[ $ver = "centos"* ]]
  then
    if [[ $ver = *"el7"* ]]
    then
      scp ./centos/tzdata-2015g-1.el7.noarch.rpm $srv:/tmp/
      ssh $srv yum update --disablerepo=* -y /tmp/tzdata-2015g-1.el7.noarch.rpm>>yum-$srv.log
      echo "$srv -> Centos 7 Timezone guncellemesi yapildi!"
    fi
    if [[ $ver = *"el6"* ]]
    then
      scp ./centos/tzdata-2015g-2.el6.noarch.rpm $srv:/tmp/
      ssh $srv yum update --disablerepo=* -y /tmp/tzdata-2015g-2.el6.noarch.rpm>>yum-$srv.log
      echo "$srv -> Centos 6 Timezone guncellemesi yapildi!"
    fi
    if [[ $ver = *"el5"* ]]
    then
      scp ./centos/tzdata-2015g-1.el5.x86_64.rpm $srv:/tmp/
      ssh $srv yum update --disablerepo=* -y /tmp/tzdata-2015g-1.el5.x86_64.rpm>>yum-$srv.log
      echo "$srv -> Centos 5 Timezone guncellemesi yapildi!"
    fi
  fi
  if [[ $ver = "redhat"* ]]
  then
    if [[ $ver = *"el7"* ]]
    then
      echo "$srv - Red Hat 7 Timezone guncellemesi icin guncelleme dosyasi eklenmeli!"
    fi
    if [[ $ver = *"el6"* ]]
    then
      scp ./rhel/tzdata-2015g-2.el6.noarch.rpm $srv:/tmp/
      ssh $srv yum update --disablerepo=* -y /tmp/tzdata-2015g-2.el6.noarch.rpm>>yum-$srv.log
      echo "$srv -> Red Hat 6 Timezone guncellemesi yapildi!"
    fi
    if [[ $ver = *"el5"* ]]
    then
      echo "$srv - Red Hat 5 Timezone guncellemesi icin guncelleme dosyasi eklenmeli!"
    fi
  fi
  if [[ $ver = "enterprise"* || $ver = "oracle"* ]]
  then
    if [[ $ver = *"release-7"* ]]
    then
      scp ./oracle/tzdata-2015g-1.el7.noarch.rpm $srv:/tmp/
      ssh $srv yum update --disablerepo=* -y /tmp/tzdata-2015g-1.el7.noarch.rpm>>yum-$srv.log
      echo "$srv -> Oracle Linux 7 Timezone guncellemesi yapildi!"
    fi
    if [[ $ver = *"release-6"* ]]
    then
      scp ./oracle/tzdata-2015g-2.el6.noarch.rpm $srv:/tmp/
      ssh $srv yum update --disablerepo=* -y /tmp/tzdata-2015g-2.el6.noarch.rpm>>yum-$srv.log
      echo "$srv -> Oracle Linux 6 Timezone guncellemesi yapildi!"
    fi
    if [[ $ver = *"release-5"* ]]
    then
      scp ./oracle/tzdata-2015g-1.el5.x86_64.rpm $srv:/tmp/
      ssh $srv yum update --disablerepo=* -y /tmp/tzdata-2015g-1.el5.x86_64.rpm>>yum-$srv.log
      echo "$srv -> Oracle Linux 5 Timezone guncellemesi yapildi!"
    fi
    if [[ $ver = *"release-4"* ]]
    then
      scp ./oracle/tzdata-2015g-1.0.1.el4.noarch.rpm $srv:/tmp/
      ssh $srv yum update --disablerepo=* -y /tmp/tzdata-2015g-1.0.1.el4.noarch.rpm>>yum-$srv.log
      echo "$srv -> Oracle Linux 4 Timezone guncellemesi yapildi!"
    fi
  fi

###
#Localtime konfigurasyonu burada
###
  tz=`ssh $srv 'diff /etc/localtime /usr/share/zoneinfo/Europe/Istanbul'`
  if [[ $? = 0 ]]
  then
    echo "$srv -> TZ OK"
  else
    `ssh $srv 'cp /usr/share/zoneinfo/Europe/Istanbul /etc/localtime'`
    echo "$srv -> TZ duzenlendi"
  fi

###
#DST Check
###
  dst=`ssh $srv 'zdump -v /etc/localtime |grep 2015'`
  if [[ $dst = *"Sun Nov  8"* ]]
  then
    echo "$srv -> DST degisikligi ${green}BASARILI!${reset}"
  else
    echo "$srv -> DST degisikligi ${red}BASARISIZ!${reset}"
  fi

done
