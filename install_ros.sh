#!/bin/sh
. ./env.sh
is_installed () {
    local package=$1
    return $(dpkg -l | grep ${package} | wc -l)
}
echo "Installing dependencies..."

ROS_INSTALLED=$(is_installed "ros-${ROS_CODENAME}")
if [ "0"=="${ROS_INSTALLED}" ] ; then
    echo ">Installing ROS Indigo. "
    echo "deb http://packages.ros.org/ros/ubuntu ${OS_CODENAME} main" > /tmp/ros-latest.list
    sudo mv -f /tmp/ros-latest.list /etc/apt/sources.list.d/ros-latest.list
    sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net --recv-key 0xB01FA116
fi

sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade

if [ "0"=="$(is_installed 'openssh-server')" ]; then
    sudo apt install -y openssh-server
fi

if [ "0"=="${ROS_INSTALLED}" ]; then
    printf 'What type of ROS installation would you like to use. [desktop-full, desktop, ros-base]:'
    reply=""
    read reply
    while [[ "desktop-full" != ${reply} && "desktop" != ${reply} && "ros-base" != ${reply} ]]
    do
        printf 'Type it again. [desktop-full, desktop, ros-base]:'
        read reply
    done
    target="ros-${ROS_CODENAME}-${reply}"
    echo "installing ${target}, python-rosinstall ..."
    sudo apt install -y ${target} python-rosinstall
#    sudo rosdep init
#    rosdep update
fi