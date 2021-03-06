#!/bin/bash

find_profile() {
    local DETECTED_PROFILE
    DETECTED_PROFILE=''
    local SHELLTYPE
    SHELLTYPE="$(basename "/$SHELL")"
    if [ "$SHELLTYPE" = "bash" ]; then
        if [ -f "$HOME/.bashrc" ]; then
            DETECTED_PROFILE="$HOME/.bashrc"
        elif [ -f "$HOME/.bash_profile" ]; then
            DETECTED_PROFILE="$HOME/.bash_profile"
        fi
    elif [ "$SHELLTYPE" = "zsh" ]; then
    DETECTED_PROFILE="$HOME/.zshrc"
    fi

    if [ -z "$DETECTED_PROFILE" ]; then
        if [ -f "$HOME/.profile" ]; then
            DETECTED_PROFILE="$HOME/.profile"
        elif [ -f "$HOME/.bashrc" ]; then
            DETECTED_PROFILE="$HOME/.bashrc"
        elif [ -f "$HOME/.bash_profile" ]; then
            DETECTED_PROFILE="$HOME/.bash_profile"
        elif [ -f "$HOME/.zshrc" ]; then
            DETECTED_PROFILE="$HOME/.zshrc"
        fi
    fi

    if [ ! -z "$DETECTED_PROFILE" ]; then
        echo "$DETECTED_PROFILE"
    fi
    return $DETECTED_PROFILE
}

export OS_DISTRIBUTOR_ID=$(lsb_release -si)
#export OS_DISTRIBUTOR_ID=Ubuntu
export OS_CODENAME=$(lsb_release -sc)
export OS_SHELL=$(basename $SHELL)
export OS_PROFILE=$(find_profile)

echo "OS_DISTRIBUTOR_ID:${OS_DISTRIBUTOR_ID}"
if [ "${OS_DISTRIBUTOR_ID}" = "Ubuntu" ] ;then
   echo "DISTRIBUTOR_ID equal Ubuntu.[${OS_DISTRIBUTOR_ID}]"
else
    # other distribution.
    echo "DISTRIBUTOR_ID:${OS_DISTRIBUTOR_ID}"
    if [ ! -f /etc/os-release ] ;then
        echo "/etc/os-release not found."
        exit 1
    fi
    OS_ID=$(cat /etc/os-release | grep -e 'ID=' --max-count=1 | sed 's/ID=//')
    OS_VERSION=$(cat /etc/os-release | grep -e 'VERSION_ID=' --max-count=1 | sed 's/VERSION_ID=//')
    if [ "${OS_VERSION}" = '"14.04"' ] ;then
        export OS_CODENAME=trusty
    elif [ "${OS_VERSION}" = '"16.04"' ] ;then
        export OS_CODENAME=xenial
    else
        echo "OS_VERSION is unknown ${OS_VERSION}."
        exit 1
    fi
fi

if [ "${OS_CODENAME}" = 'trusty' ]; then
    ROS_CODENAME="indigo"
elif [ "${OS_CODENAME}" = 'xenial' ]; then
    ROS_CODENAME="kinetic"
else
    echo "OS_CODENAME is unknown ${OS_CODENAME}"
    exit 1
fi

echo "OS_DISTRIBUTOR_ID:${OS_DISTRIBUTOR_ID}"
echo "OS_CODENAME      :${OS_CODENAME}"
echo "OS_SHELL         :${OS_SHELL}"
echo "OS_PROFILE       :${OS_PROFILE}"
echo "ROS_CODENAME     :${ROS_CODENAME}"
