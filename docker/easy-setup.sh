#!/bin/bash
#
# Copyright(C) 2021, Stamus Networks
# Written by Raphaël Brogat <rbrogat@stamus-networks.com> based on the work of Peter Manev <pmanev@stamus-networks.com>
#
# Please run on Debian
#
# This script comes with ABSOLUTELY NO WARRANTY!
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

MINIMAL_DOCKER_VERSION="17.06.0"
MINIMAL_COMPOSE_VERSION="1.27.0"



############################################################
#                                                          #
#                 PARSING HELPER FUNCTIONS                 #
#          JUMP TO LINE 474 FOR THE ACTUAL SCRIPT          #
#                                                          #
############################################################

# Partially Generated with Argbash
### TEMPLATE
#
# ARG_HELP([SELKS setup script])
#
# ARG_OPTIONAL_REPEATED([interface],[i],[Defines an interface on which SELKS should listen.\This options can be called multiple times. Ex : easy-setup.sh -i eth0 -i eth1.])
#
# ARG_OPTIONAL_BOOLEAN([debug],[d],[Activate debug mode for scirius and nginx.])
#
# ARG_OPTIONAL_BOOLEAN([non-interactive],[n],[Run the script without interactive prompt.])
#
# ARG_OPTIONAL_BOOLEAN([install-docker],[],[Install docker on the fly if not found])
#
# ARG_OPTIONAL_BOOLEAN([install-compose],[],[Install docker-compose on the fly if not found])
#
# ARG_OPTIONAL_BOOLEAN([install-portainer],[],[Install portainer on the fly if not found])
#
# ARG_OPTIONAL_BOOLEAN([install-all],[],[Install docker, docker-compose and portainer on the fly if not found])
#
# ARG_OPTIONAL_BOOLEAN([skip-checks],[s],[Run the script without checking if docker and docker-compose are installed.\nUse this only if you know that both docker and docker-compose are already installed with proper versions.\nOtherwise, the script will probably fail])
#
# ARG_OPTIONAL_BOOLEAN([pull-containers],[],[Skip pulling the containers at the end of the script.\nUsefull when no internet connection is available.],[on])
#
# ARG_OPTIONAL_SINGLE([scirius-version],[],[Defines the version of scirius to use.\nThe version can be a branch name, a github tag or a commit hash. Default is 'master'])
#
# ARG_OPTIONAL_SINGLE([elk-version],[],[Defines the version of the ELK stack to use. Default is '7.15.1'.\nThe version should match a tag of Elasticsearch, Kibana and Logstash images on the dockerhub])
#
# ARG_OPTIONAL_SINGLE([es-datapath],[],[Defines the path where Elasticsearch will store it's data.\nThe path must already exists and the current user must have write permissions.\nDefault will be in a named docker volume ('/var/lib/docker')])
#
# ARG_OPTIONAL_SINGLE([es-memory],[],[Amount of memory to give to the elasticsearch container.\nAccepted units are 'm','M','g','G'. ex \"--es-memory 512m\" or \"--es-memory 4G\".\nDefault is '3G'])
#
# ARG_OPTIONAL_SINGLE([ls-memory],[],[Amount of memory to give to the logstash container.\nAccepted units are 'm','M','g','G'. ex \"--ls-memory 512m\" or \"--ls-memory 4G\".\nDefault is '2G'])
#
# ARG_OPTIONAL_SINGLE([restart-mode],[],['no': never restart automatically the containers\n'always': automatically restart the containers even if they have been manually stopped\n'on-failure': only restart the containers if they failed\n'unless-stopped': always restart the container except if it has been manually stopped])
#
# ARG_OPTIONAL_BOOLEAN([print-options],[],[print how the options have been interpreted and exit])
#
# ARG_POSITIONAL_DOUBLEDASH([])
# ARGBASH_SET_INDENT([  ])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.9.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info
# Generated online by https://argbash.io/generate


# # When called, the process ends.
# Args:
#   $1: The exit message (print to stderr)
#   $2: The exit code (default is 1)
# if env var _PRINT_HELP is set to 'yes', the usage is print to stderr (prior to $1)
# Example:
#   test -f "$_arg_infile" || _PRINT_HELP=yes die "Can't continue, have to supply file as an argument, got '$_arg_infile'" 4
die()
{
  local _ret="${2:-1}"
  test "${_PRINT_HELP:-no}" = yes && print_help >&2
  echo "$1" >&2
  exit "${_ret}"
}


# Function that evaluates whether a value passed to it begins by a character
# that is a short option of an argument the script knows about.
# This is required in order to support getopts-like short options grouping.
begins_with_short_option()
{
  local first_option all_short_options='hidns'
  first_option="${1:0:1}"
  test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_interface=()
_arg_debug="off"
_arg_non_interactive="off"
_arg_install_docker="off"
_arg_install_compose="off"
_arg_install_portainer="off"
_arg_install_all="off"
_arg_skip_checks="off"
_arg_pull_containers="on"
_arg_scirius_version=
_arg_elk_version=
_arg_es_datapath=
_arg_es_memory=
_arg_ls_memory=
_arg_restart_mode=
_arg_print_options="off"


# Function that prints general usage of the script.
# This is useful if users asks for it, or if there is an argument parsing error (unexpected / spurious arguments)
# and it makes sense to remind the user how the script is supposed to be called.
print_help()
{
  printf '%s\n' "SELKS setup script"
  printf 'Usage: %s [-h|--help] [-i|--interface <arg>] [-d|--debug] [-n|--non-interactive] [--install-docker] [--install-compose] [--install-portainer] [--install-all] [-s|--skip-checks] [--no-pull-containers] [--scirius-version <arg>] [--elk-version <arg>] [--es-datapath <arg>] [--es-memory <arg>] [--ls-memory <arg>] [--restart-mode <arg>] [--print-options]\n' "$0"
  printf '\t%s\n\n' "-h, --help: Prints help"
  printf '\t%s\n\n' "-i, --interface: Defines an interface on which SELKS should listen.
    This options can be called multiple times. Ex : easy-setup.sh -i eth0 -i eth1."
  printf '\t%s\n\n' "-d, --debug: Activate debug mode for scirius and nginx."
  printf '\t%s\n\n' "-n, --non-interactive: Run the script without interactive prompt."
  printf '\t%s\n\n' "--iD, --install-docker: Install docker on the fly if not found"
  printf '\t%s\n\n' "--iC, --install-compose: Install docker-compose on the fly if not found"
  printf '\t%s\n\n' "--iP, --install-portainer: Install portainer on the fly if not found"
  printf '\t%s\n\n' "--iA, --install-all: Install docker, docker-compose and portainer on the fly if not found"
  printf '\t%s\n\n' "-s, --skip-checks: Run the script without checking if docker and docker-compose are installed.
		Use this only if you know that both docker and docker-compose are already installed with proper versions.
		Otherwise, the script will probably fail"
  printf '\t%s\n\n' "--no-pull-containers: Skip pulling the containers at the end of the script.
		Usefull when no internet connection is available."
  printf '\t%s\n\n' "--scirius-version: Defines the version of scirius to use.
		The version can be a branch name, a github tag or a commit hash. Default is 'master'"
  printf '\t%s\n\n' "--elk-version: Defines the version of the ELK stack to use. Default is '7.15.1'.
		The version should match a tag of Elasticsearch, Kibana and Logstash images on the dockerhub"
  printf '\t%s\n\n' "--es-datapath: Defines the path where Elasticsearch will store it's data.
		The path must already exists and the current user must have write permissions.
		Default will be in a named docker volume ('/var/lib/docker')"
  printf '\t%s\n\n' "--es-memory: Amount of memory to give to the elasticsearch container.
		Accepted units are 'm','M','g','G'. ex \"--es-memory 512m\" or \"--es-memory 4G\".
		Default is '3G'"
  printf '\t%s\n\n' "--ls-memory: Amount of memory to give to the logstash container.
		Accepted units are 'm','M','g','G'. ex \"--ls-memory 512m\" or \"--ls-memory 4G\".
		Default is '2G'"
  printf '\t%s\n\n' "--restart-mode: 'no': never restart automatically the containers
		'always': automatically restart the containers even if they have been manually stopped
		'on-failure': only restart the containers if they failed
		'unless-stopped': always restart the container except if it has been manually stopped"
  printf '\t%s\n\n' "--print-options: print how the options have been interpreted and exit"
}


# The parsing of the command-line
parse_commandline()
{
  while test $# -gt 0
  do
    _key="$1"
    case "$_key" in
      # The help argurment doesn't accept a value,
      # we expect the --help or -h, so we watch for them.
      -h|--help)
        print_help
        exit 0
        ;;
      # We support getopts-style short arguments clustering,
      # so as -h doesn't accept value, other short options may be appended to it, so we watch for -h*.
      # After stripping the leading -h from the argument, we have to make sure
      # that the first character that follows coresponds to a short option.
      -h*)
        print_help
        exit 0
        ;;
      # We support whitespace as a delimiter between option argument and its value.
      # Therefore, we expect the --interface or -i value.
      # so we watch for --interface and -i.
      # Since we know that we got the long or short option,
      # we just reach out for the next argument to get the value.
      -i|--interface)
        test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
        _arg_interface+=("$2")
        shift
        ;;
      # We support the = as a delimiter between option argument and its value.
      # Therefore, we expect --interface=value, so we watch for --interface=*
      # For whatever we get, we strip '--interface=' using the ${var##--interface=} notation
      # to get the argument value
      --interface=*)
        _arg_interface+=("${_key##--interface=}")
        ;;
      # We support getopts-style short arguments grouping,
      # so as -i accepts value, we allow it to be appended to it, so we watch for -i*
      # and we strip the leading -i from the argument string using the ${var##-i} notation.
      -i*)
        _arg_interface+=("${_key##-i}")
        ;;
      # See the comment of option '--help' to see what's going on here - principle is the same.
      -d|--debug)
        _arg_debug="on"
        test "${1:0:5}" = "--no-" && _arg_debug="off"
        ;;
      # See the comment of option '-h' to see what's going on here - principle is the same.
      -d*)
        _arg_debug="on"
        _next="${_key##-d}"
        if test -n "$_next" -a "$_next" != "$_key"
        then
          { begins_with_short_option "$_next" && shift && set -- "-d" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
        fi
        ;;
      # See the comment of option '--help' to see what's going on here - principle is the same.
      -n|--non-interactive)
        _arg_non_interactive="on"
        ;;
      # See the comment of option '-h' to see what's going on here - principle is the same.
      -n*)
        _arg_non_interactive="on"
        _next="${_key##-n}"
        if test -n "$_next" -a "$_next" != "$_key"
        then
          { begins_with_short_option "$_next" && shift && set -- "-n" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
        fi
        ;;
      # See the comment of option '--help' to see what's going on here - principle is the same.
      --iD|--install-docker)
        _arg_install_docker="on"
        ;;
      # See the comment of option '--help' to see what's going on here - principle is the same.
      --iC|--install-compose)
        _arg_install_compose="on"
        ;;
      # See the comment of option '--help' to see what's going on here - principle is the same.
      --iP|--install-portainer)
        _arg_install_portainer="on"
        ;;
      # See the comment of option '--help' to see what's going on here - principle is the same.
      --iA|--install-all)
        _arg_install_all="on"
        ;;
      # See the comment of option '--help' to see what's going on here - principle is the same.
      -s|--skip-checks)
        _arg_skip_checks="on"
        ;;
      # See the comment of option '-h' to see what's going on here - principle is the same.
      -s*)
        _arg_skip_checks="on"
        _next="${_key##-s}"
        if test -n "$_next" -a "$_next" != "$_key"
        then
          { begins_with_short_option "$_next" && shift && set -- "-s" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
        fi
        ;;
      # See the comment of option '--help' to see what's going on here - principle is the same.
      --no-pull-containers)
         _arg_pull_containers="off"
        ;;
      # See the comment of option '--interface' to see what's going on here - principle is the same.
      --scirius-version)
        test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
        _arg_scirius_version="$2"
        shift
        ;;
      # See the comment of option '--interface=' to see what's going on here - principle is the same.
      --scirius-version=*)
        _arg_scirius_version="${_key##--scirius-version=}"
        ;;
      # See the comment of option '--interface' to see what's going on here - principle is the same.
      --elk-version)
        test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
        _arg_elk_version="$2"
        shift
        ;;
      # See the comment of option '--interface=' to see what's going on here - principle is the same.
      --elk-version=*)
        _arg_elk_version="${_key##--elk-version=}"
        ;;
      # See the comment of option '--interface' to see what's going on here - principle is the same.
      --es-datapath)
        test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
        _arg_es_datapath="$2"
        shift
        ;;
      # See the comment of option '--interface=' to see what's going on here - principle is the same.
      --es-datapath=*)
        _arg_es_datapath="${_key##--es-datapath=}"
        ;;
      # See the comment of option '--interface' to see what's going on here - principle is the same.
      --es-memory)
        test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
        _arg_es_memory="$2"
        shift
        ;;
      # See the comment of option '--interface=' to see what's going on here - principle is the same.
      --es-memory=*)
        _arg_es_memory="${_key##--es-memory=}"
        ;;
      # See the comment of option '--interface' to see what's going on here - principle is the same.
      --ls-memory)
        test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
        _arg_ls_memory="$2"
        shift
        ;;
      # See the comment of option '--interface=' to see what's going on here - principle is the same.
      --ls-memory=*)
        _arg_ls_memory="${_key##--ls-memory=}"
        ;;
      # See the comment of option '--interface' to see what's going on here - principle is the same.
      --restart-mode)
        test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
        _arg_restart_mode="$2"
        shift
        ;;
      # See the comment of option '--interface=' to see what's going on here - principle is the same.
      --restart-mode=*)
        _arg_restart_mode="${_key##--restart-mode=}"
        ;;
      # See the comment of option '--help' to see what's going on here - principle is the same.
      --print-options)
        _arg_print_options="on"
        ;;
      *)
        _PRINT_HELP=yes die "FATAL ERROR: Got an unexpected argument '$1'" 1
        ;;
    esac
    shift
  done
}

# Now call all the functions defined above that are needed to get the job done
parse_commandline "$@"

# OTHER STUFF GENERATED BY Argbash

### END OF CODE GENERATED BY Argbash (sortof) ### ])


############################################################
# Functions for the ISO build                               #
############################################################
function load_docker_images_from_tar(){
  tar_path="$1"
  if [ -d "$tar_path" ]; then
    echo -e "Found docker images tarballs"
    for filename in $tar_path/*.tar; do
    ((loaded_images++))
    echo -e "\n Loading $filename into docker"
      docker load -i "$filename"
    done
  fi
}


############################################################
# Docker-related Functions                                 #
############################################################
function is_docker_installed(){
  dockerV=$(docker -v 2>/dev/null)
  if [[ "${dockerV}" == *"Docker version"* ]]; then
    echo "yes"
  else
    echo "no"
  fi
}
function is_compose_installed(){
  composeV=$(docker-compose --version 2>/dev/null)
  if [[ $composeV == *"docker-compose version"* ]]; then
    echo "yes"
  else
    echo "no"
  fi
}
function is_docker_availabale_for_user(){
  dockerV=$(docker version --format '{{.Server.Version}}' 2>/dev/null)
  if [[ ! -z "$dockerV" ]]; then
    echo "yes"
  else
    echo "no"
  fi
}
function test_docker(){
  hello=$(docker run --rm hello-world) || \
  echo "${red}-${reset} Docker test failed"
  
  if [[ $hello == *"Hello from Docker"* ]]; then
    echo -e "${green}+${reset} Docker seems to be installed properly"
  else
    echo -e "${red}-${reset} Error running docker."
    exit 1
  fi
}
function install_docker(){
  curl -fsSL https://get.docker.com -o get-docker.sh && \
  sh get-docker.sh || \
  { echo "${red}-${reset} Docker installation failed" && exit ; }
  echo "${green}+${reset} Docker installation succeeded"
  systemctl enable docker && \
  systemctl start docker
}
function install_docker_compose(){
  curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
  chmod +x /usr/local/bin/docker-compose && \
  echo "${green}+${reset} docker-compose installation succeeded" || \
  { echo "${red}-${reset} docker-compose installation failed" && exit ; }
}
function install_portainer(){
  docker volume create portainer_data && \
  docker run -d -p 9443:9443 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce --logo "https://www.stamus-networks.com/hubfs/stamus_logo_blue_cropped-2.png" && \
  PORTAINER_INSTALLED="true" && \
  echo -e "${green}+${reset} Portainer has been installed and will be available on port 9443" || \
  echo -e "${red}-${reset} Portainer installation failed\n"
}
function Version(){
  # $1-a $2-op $3-$b
  # Compare a and b as version strings. Rules:
  # R1: a and b : dot-separated sequence of items. Items are numeric. The last item can optionally end with letters, i.e., 2.5 or 2.5a.
  # R2: Zeros are automatically inserted to compare the same number of items, i.e., 1.0 < 1.0.1 means 1.0.0 < 1.0.1 => yes.
  # R3: op can be '=' '==' '!=' '<' '<=' '>' '>=' (lexicographic).
  # R4: Unrestricted number of digits of any item, i.e., 3.0003 > 3.0000004.
  # R5: Unrestricted number of items.
  local a=$1 op=$2 b=$3 al=${1##*.} bl=${3##*.}
  while [[ $al =~ ^[[:digit:]] ]]; do al=${al:1}; done
  while [[ $bl =~ ^[[:digit:]] ]]; do bl=${bl:1}; done
  local ai=${a%$al} bi=${b%$bl}

  local ap=${ai//[[:digit:]]} bp=${bi//[[:digit:]]}
  ap=${ap//./.0} bp=${bp//./.0}

  local w=1 fmt=$a.$b x IFS=.
  for x in $fmt; do [ ${#x} -gt $w ] && w=${#x}; done
  fmt=${*//[^.]}; fmt=${fmt//./%${w}s}
  printf -v a $fmt $ai$bp; printf -v a "%s-%${w}s" $a $al
  printf -v b $fmt $bi$ap; printf -v b "%s-%${w}s" $b $bl

  case $op in
    '<='|'>=' ) [ "$a" ${op:0:1} "$b" ] || [ "$a" = "$b" ] ;;
    * )         [ "$a" $op "$b" ] ;;
  esac
}
function check_docker_version(){
  dockerV=$(docker version --format '{{.Server.Version}}')

  if Version $dockerV '<' "${MINIMAL_DOCKER_VERSION}"; then
    echo -e "${red}-${reset} Docker version is too old, please upgrade it to ${MINIMAL_DOCKER_VERSION} minimum"
    exit
  fi
}
function check_compose_version(){
  composeV=$(docker-compose --version)
  composeV=( $composeV )
  composeV=$( echo ${composeV[2]} |tr ',' ' ')

  if Version $composeV '<' "${MINIMAL_COMPOSE_VERSION}"; then
    echo -e "${red}-${reset} Docker version is too old, please upgrade it to ${MINIMAL_COMPOSE_VERSION} minimum"
    exit
  fi
}

##################################################################################
#                                    START                                       #
##################################################################################

# Setting variables

[ "${_arg_non_interactive}" == "on" ] && INTERACTIVE="false" || INTERACTIVE="true"
if [ "${_arg_install_all}" == "on" ];then
  _arg_install_docker="on"
  _arg_install_compose="on"
  _arg_install_portainer="on"
fi
INTERFACES=$(printf " %s" "${_arg_interface[@]}")
INTERFACES=${INTERFACES:1}




if [[ "${INTERACTIVE}" == "false" ]] && [[ "${INTERFACES}" == "" ]]; then
  echo "ERROR: --non-interactive option must be use with --interface option"
  exit 1
fi

if [[ "${_arg_print_options}" == "on" ]]; then
  # Print the variables
  echo "DEBUG = ${_arg_debug}" #
  echo "INTERFACES = ${INTERFACES}" #
  echo "INTERACTIVE = ${INTERACTIVE}" #
  echo "INSTALL_DOCKER = ${_arg_install_docker}" #
  echo "INSTALL_COMPOSE = ${_arg_install_compose}" #
  echo "INSTALL_PORTAINER = ${_arg_install_portainer}" #
  echo "INSTALL_ALL = ${_arg_install_all}" #
  echo "SKIP_CHECKS = ${_arg_skip_checks}" #
  echo "PULL_CONTAINERS = ${_arg_pull_containers}" #
  echo "SCIRIUS_VERSION = ${_arg_scirius_version}" #
  echo "ELK_VERSION = ${_arg_elk_version}" #
  echo "ELASTIC_DATAPATH = ${_arg_es_datapath}" #
  echo "RESTART_MODE = ${_arg_restart_mode}" #
  echo "ELASTIC_MEMORY = ${_arg_es_memory}" #
  echo "LOGSTASH_MEMORY = ${_arg_ls_memory}" #
  if [[ "${INTERACTIVE}" == "true" ]] ; then
    read
  fi
  exit 0
fi


#################################################
# Check if root and curl are needed             #
#################################################


if [[ $(is_docker_installed) == "no" || $(is_compose_installed) == "no" ]]; then
  if [[ $EUID -ne 0 ]]; then
   ROOT_NEEDED="true"
  fi
  if [[ -z "$(curl -V)" ]]; then
    CURL_NEEDED="true"
  fi
else
  if [[ $(is_docker_availabale_for_user) == "no" ]]; then
    ROOT_NEEDED="true"
  fi
fi

if [[ "${CURL_NEEDED}" == "true" && "${ROOT_NEEDED}" == "true" ]]; then
  echo "Curl not found. Please install curl and re-run this script as root or with sudo"
  exit 1
fi

if [[ "${ROOT_NEEDED}" == "true" ]]; then
  echo "Please run this script as root or with sudo"
  exit 1
fi


##########################
# Set the colors         #
##########################

red=`tput setaf 1``tput bold`
green=`tput setaf 2``tput bold`
reset=`tput sgr0`
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"


echo -e "DISCLAIMER : This script comes with absolutely no warranty. It provides a quick and easy way to install SELKS on your system\n
Altough this script should run properly on major linux distribution, it has only been tested on Debian 10, Debian 11, Ubuntu 20.04 and Centos 8\n"

if [[ "${INTERACTIVE}" == "true" ]] ; then
  echo "Press any key to continue or ^c to exit"
  read
fi
echo -e "  This version of SELKS relies on docker containers. We will now check if docker is already installed"

echo -e "\n"
echo "##################"
echo "#  INSTALLATION  #"
echo "##################"
echo -e "\n"


load_docker_images_from_tar ${BASEDIR}/tar_images

if [[ "${_arg_skip_checks}" == "off" ]] ; then
  
  #############################
  #          DOCKER           #
  #############################  

  if [[ $(is_docker_installed) == "yes" ]]; then
    echo -e "${green}+${reset} Docker installation found: $(docker -v)"
  else
    echo -e "${red}-${reset} No docker installation found\n\n  We can try to install docker for you"
    echo -e "  Do you want to install docker automatically? [y/N] "
    if [[ "${_arg_install_docker}" == "on" ]]; then
      yn="y"
      echo "y"
    else
      if [[ "${INTERACTIVE}" == "true" ]]; then
        read yn
      else
        yn="N"
        echo "N"
      fi
    fi
    case $yn in
        [Yy]* ) install_docker;;
        * ) echo -e "  See https://docs.docker.com/engine/install to learn how to install docker on your system"; exit;;
    esac
  fi

  check_docker_version

  test_docker

  #############################
  #      DOCKER-COMPOSE       #
  #############################

  if [[ "$(is_compose_installed)" == "yes" ]]; then
    echo -e "${green}+${reset} docker-compose installation found"
  else
    echo -e "${red}-${reset} No docker-compose installation found, see https://docs.docker.com/compose/install/ to learn how to install docker-compose on your system"
    echo -e "  Do you want to install docker-compose automatically? [y/N] "
    if [[ "${_arg_install_compose}" == "on" ]]; then
      yn="y"
      echo "y"
    else
      if [[ "${INTERACTIVE}" == "true" ]]; then
        read yn
      else
        yn="N"
        echo "N"
      fi
    fi
    case $yn in
        [Yy]* ) install_docker_compose;;
        * ) echo -e "  See https://docs.docker.com/compose/install/ to learn how to install docker-compose on your system"; exit;;
    esac
  fi

  check_compose_version


  #############################
  #         PORTAINER         #
  #############################
  
  if $(docker ps | grep -q 'portainer'); then
    echo -e "  Found existing portainer installation, skipping...\n"
  else
    echo -e "\n  Portainer is a web interface for managing docker containers. It is recommended if you are not experienced with docker."
    while true; do
        echo -e "  Do you want to install Portainer ? [y/n] "
        if [[ "${_arg_install_portainer}" == "on" ]]; then
          yn="y"
          echo "y"
        else
          if [[ "${INTERACTIVE}" == "true" ]]; then
            read yn
          else
            yn="N"
            echo "N"
          fi
        fi
        case $yn in
            [Yy]* ) install_portainer; break;;
            [Nn]* ) break;;
            * ) echo -e "  Please answer Y or N";;
        esac
    done
  fi
  
fi

#############################
# GENERATE SSL CERTIFICATES #
#############################
SSLDIR="${BASEDIR}/containers-data/nginx/ssl"

function check_scirius_key_cert(){
  # usage : check_scirius_key_cert [path_to_files] [filename_without_extension]
  # example : check_scirius_key_cert [path_to_files] [filename_without_extension]
  output=$(docker run --rm -it -v ${1}:/etc/nginx/ssl nginx /bin/bash -c "openssl x509 -in /etc/nginx/ssl/scirius.crt -pubkey -noout -outform pem | sha256sum; openssl pkey -in /etc/nginx/ssl/scirius.key -pubout -outform pem | sha256sum" || echo -e "${red}-${reset} Error while checking certificate against key")
  
  SAVEIFS=$IFS   # Save current IFS
  IFS=$'\n'      # Change IFS to new line
  output=($output) # split to array $names
  IFS=$SAVEIFS   # Restore IFS
  
  if [[ ${output[0]}==${output[1]} ]]; then
    echo -e "${green}+${reset} Certificate match private key"
    return 0
  else
    echo -e "${red}-${reset} Certificate does not match private key"
    echo -e "${output[0]}"
    echo -e "${output[1]}"
    return 1

  fi
}
function generate_scirius_certificate(){
  docker run --rm -it -v ${1}:/etc/nginx/ssl nginx openssl req -new -nodes -x509 -subj "/C=FR/ST=IDF/L=Paris/O=Stamus/CN=SELKS" -days 3650 -keyout /etc/nginx/ssl/scirius.key -out /etc/nginx/ssl/scirius.crt -extensions v3_ca && echo -e "${green}+${reset} Certificate generated successfully" || echo -e "${red}-${reset} Error while generating certificate with openssl"
  check_scirius_key_cert ${1}
  return $?
}


if [ -f "${SSLDIR}/scirius.crt" ] && [ -f "${SSLDIR}/scirius.key" ] && check_scirius_key_cert ${SSLDIR}; then
  echo -e "  A valid SSL certificate has been found:\n\t${SSLDIR}/scirius.crt"
  echo -e "  Skipping SSL generation..."
else
  generate_scirius_certificate ${SSLDIR}
fi



echo -e "\n"
echo "##################"
echo "#    SETTINGS    #"
echo "##################"
echo -e "\n"


######################
# Setting Stack name #
######################
echo "COMPOSE_PROJECT_NAME=SELKS" > ${BASEDIR}/.env

#############
# INTERFACE #
#############

function getInterfaces {
  echo -e " Network interfaces detected:"
  intfnum=0
  for interface in $(ls /sys/class/net); do echo "${intfnum}: ${interface}"; ((intfnum++)) ; done
  
  echo -e "Please type in interface or space delimited interfaces below and hit \"Enter\"."
  echo -e "Choose the interface(s) that is (are) one the network(s) you want to monitor"
  echo -e "Example: eth1"
  echo -e "OR"
  echo -e "Example: eth1 eth2 eth3"
  echo -e "\nConfigure threat detection for INTERFACE(S): "
  
  if [[ "${INTERFACES}" == "" ]] && [[ "${INTERACTIVE}" == "true" ]]; then
    read interfaces
  else
    echo "${INTERFACES}"
    interfaces=${INTERFACES}
  fi
    
  echo -e "\nThe supplied network interface(s):  ${interfaces}"
  echo "";
  INTERFACE_EXISTS="YES"
  if [ -z "${interfaces}" ] ; then
    echo -e "\nNo input provided at all."
    echo -e "Exiting with ERROR...."
    INTERFACE_EXISTS="NO"
    exit 1
  fi
  
  for interface in ${interfaces}
  do
    if ! cat /sys/class/net/${interface}/operstate > /dev/null 2>&1 ; then
        echo -e "\nUSAGE: `basename $0` -> the script requires at least 1 argument - a network interface!"
        echo -e "#######################################"
        echo -e "Interface: ${interface} is NOT existing."
        echo -e "#######################################"
        echo -e "Please supply a correct/existing network interface or check your spelling.\n"
        INTERFACE_EXISTS="NO"
    fi
    
  done
}


getInterfaces

while [[ ${INTERFACE_EXISTS} == "NO"  ]]; do
  INTERFACES=""
  if [[ ${INTERACTIVE} == "false" ]]; then
    echo "This interface does not exists"
    exit 1
  fi
  getInterfaces
done

for interface in ${interfaces}
do
  INTERFACES_LIST=${INTERFACES_LIST}\ -i\ ${interface}
done

echo "INTERFACES=${INTERFACES_LIST}" >> ${BASEDIR}/.env


##############
# DEBUG MODE #
##############

echo -e "Do you want to use debug mode? [y/N] "
if [[ "${_arg_debug}" == "on" ]]; then
  echo "y"
  yn="y"
else
  if [[ ${INTERACTIVE} == "true" ]]; then
    read yn
  else
    echo "N"
    yn="n"
  fi
fi
case $yn in
    [Yy]* ) echo "SCIRIUS_DEBUG=True" >> ${BASEDIR}/.env; echo "NGINX_EXEC=nginx-debug" >> ${BASEDIR}/.env; break;;
    * ) ;;
esac

echo

################
# RESTART MODE #
################

echo -e "Do you want the containers to restart automatically on startup? [Y/n] "
if [[ ! -z "${_arg_restart_mode}" ]]; then
  echo "${_arg_restart_mode}"
  yn="${_arg_restart_mode}"
else
  if [[ ${INTERACTIVE} == "true" ]]; then
    read answer
  else
    echo "Y"
    yn="Y"
  fi
fi
case $yn in
    [Nn]* ) echo "RESTART_MODE=on-failure" >> ${BASEDIR}/.env; break;;
    * ) ;;
esac

echo

######################
# ELASTIC DATA PATH #
######################

docker_root_dir=$(docker system info |grep "Docker Root Dir")
docker_root_dir=${docker_root_dir/'Docker Root Dir: '/''}

echo ""
echo -e "By default, elasticsearch database is stored in a docker volume in ${docker_root_dir} (free space: $(df --output=avail -h ${docker_root_dir} | tail -n 1 )"
echo -e "With SELKS running, database can take up a lot of disk space"
echo -e "You might want to save them on an other disk/partition"
echo -e "Alternatively, You can specify a path where you want the data to be saved, or hit enter for default."

if [[ "${_arg_es_datapath}" == "" ]] && [[ "${INTERACTIVE}" == "true" ]]; then
  read elastic_data_path
else
  echo "${_arg_es_datapath}"
  elastic_data_path=${_arg_es_datapath}
fi

if ! [ -z "${elastic_data_path}" ]; then

  while ! [ -w "${elastic_data_path}" ]; do 
    echo -e "\nYou don't seem to own write access to this directory\n"
    echo -e "You can specify a path where you want the data to be saved, or hit ENTER to use a [docker volume]."
    if [[ "${INTERACTIVE}" == "true" ]]; then
      read elastic_data_path
    else
      exit
    fi

  done
echo "ELASTIC_DATAPATH=${elastic_data_path}" >> ${BASEDIR}/.env
fi

#####################
# ELASTIC MEMORY    #
#####################
: '
echo -e "By default, elasticsearch will get attributed 2G of RAM"
echo -e "You can specify a different value or hit enter : [2G]"
echo -e "(Accepted units are 'm','M','g','G'. Ex: \"512m\" or \"4G\")"

if [[ "${ELASTIC_MEMORY}" == "" ]] && [[ "${INTERACTIVE}" == "true" ]]; then
  read ELASTIC_MEMORY
else
  echo "${ELASTIC_MEMORY}"
fi
'
if ! [ -z "${_arg_es_memory}" ]; then
  echo "ELASTIC_MEMORY=${_arg_es_memory}" >> ${BASEDIR}/.env
fi

#####################
# LOGSTASH MEMORY    #
#####################

if ! [ -z "${_arg_ls_memory}" ]; then
  echo "LOGSTASH_MEMORY=${_arg_ls_memory}" >> ${BASEDIR}/.env
fi

###########################
# Generate KEY FOR DJANGO #
###########################

output=$(docker run --rm -it python:3.9.5-slim-buster /bin/bash -c "python -c \"import secrets; print(secrets.token_urlsafe())\"")

echo "SCIRIUS_SECRET_KEY=${output}" >> ${BASEDIR}/.env



##################################
# Setting Scirius branch to use #
##################################
if [ ! -z "${_arg_scirius_version}" ] ; then
  echo "SCIRIUS_VERSION=$_arg_scirius_version" >> ${BASEDIR}/.env
fi

#############################
# Setting ELK VERSION to use #
#############################
if [ ! -z "${_arg_elk_version}" ] ; then
  echo "ELK_VERSION=$_arg_elk_version" >> ${BASEDIR}/.env
fi


#######################################
# Disable ML if SSE 4.2 not supported #
#######################################

if ! grep -q sse4_2 /proc/cpuinfo; then
  echo "ML_ENABLED=false" >> ${BASEDIR}/.env
fi


######################
# PULLING           #
######################
if [[ "${_arg_pull_containers}" == "on" ]]; then
  echo -e "\n"
  echo "#######################"
  echo "# PULLING  CONTAINERS #"
  echo "#######################"
  echo -e "\n"

  docker-compose pull || exit

fi


######################
# Starting           #
######################
echo -e "\n\n${green}To start SELKS, run 'sudo docker-compose up -d'${reset}\n"

if [[ "$PORTAINER_INSTALLED" == "true" ]]; then
  echo -e "${red}IMPORTANT:${reset} You chose to install Portainer, visit https://localhost:9443 to set your portainer admin password"
fi
