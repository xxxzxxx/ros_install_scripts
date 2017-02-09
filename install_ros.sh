#!/bin/sh
. ./env.sh
is_installed () {
    local package=$1
    return "$(dpkg -l | grep ${package} | wc -l)"
}
echo "Installing dependencies..."

$(is_installed "ros-${ROS_CODENAME}")
ROS_INSTALLED=$?
echo "ROS_INSTALLED:${ROS_INSTALLED}"
if [ "0" = ${ROS_INSTALLED} ]; then
     :
else
     echo "ros installed."
     exit 0
fi

if [ "0" = ${ROS_INSTALLED} ] ; then
    echo ">Installing ROS Indigo. "
    echo "deb http://packages.ros.org/ros/ubuntu ${OS_CODENAME} main" > /tmp/ros-latest.list
    sudo mv -f /tmp/ros-latest.list /etc/apt/sources.list.d/ros-latest.list
    sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net --recv-key 0xB01FA116
fi

if [ "0" = ${ROS_INSTALLED} ]; then
    sudo apt-get -y update
    sudo apt-get -y upgrade
    sudo apt-get -y dist-upgrade
    printf 'What type of ROS installation would you like to use. [desktop-full, desktop, ros-base]:'
    reply=""
    read reply
    while :
    do
        if [ "desktop-full" != ${reply} ]; then
            break;
        elif [ "desktop" != ${reply} ]; then
            break;
        elif [ "ros-base" != ${reply} ]; then
            break;
        else
            printf 'Type it again. [desktop-full, desktop, ros-base]:'
            read reply
        fi
    done
    target="ros-${ROS_CODENAME}-${reply}"
    echo "installing ${target}, python-rosinstall ..."
    sudo apt install -y ${target} python-rosinstall
fi
if [ ! -f ~/.ros_profile ]; then
printf "export PATH=/opt/ros/${ROS_CODENAME}/bin/;" > ~/.ros_profile
echo '${PATH}' >> ~/.ros_profile
echo '
if [ -f ${HOME}/.ros_profile ]; then
  source ${HOME}/.ros_profile
fi
' >> ${HOME}/.profile
fi