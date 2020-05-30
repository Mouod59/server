#!/bin/bash
function logo 
{
	clear
	echo -e "  ${yellow}
   ____
  / ___|  ___ _ ____   _____ _ __
  \___ \ / _ \ '__\ \ / / _ \ '__|${nc}
   ___) |  __/ |   \ V /  __/ |
  |____/ \___|_|    \_/ \___|_|
	"
}

function main
{
	while [ true ];do
	
	logo
	
	echo -e "${yellow}"
	echo "  [1]start php web server"
	echo "  [2]start node.js web server"
	echo "  [3]start python web server"
	echo "  [4]start mysql database"
	echo "  [5]change settings"
	echo "  [6]about us"
	echo "  [0]exit"
	echo -e "\n"
	read -p "  >> " num

		case "$num" in 
			"1")
			if [ `dpkg -s php | grep -c "ok installed"` == "1" ];then
				if [ -z "$php_path" ] || [ -z "$php_port" ];then
					get_php_input
					start_php
				else
					start_php
				fi
			else
				logo
				echo -e "${yellow}  php was not installed do you want to install it [y/n]\n"
				read -p "  >> " nm
				if [ "$nm" == "y" ];then
					apt install php -y
					if [ "$?" == "0" ];then
						get_php_input
						start_php
					else
						clear
                        logo
                        echo -e "${yellow}  error while installing, try again"
                        sleep 2
					fi
				fi
			fi
			;;
			"2")
			  if [ `dpkg -s nodejs | grep -c "ok installed"` == "1" ];then
				if [ -z "$node_path" ] || [ -z "$node_port" ];then
					get_node_input
					start_node
				else
					start_node
				fi
			  else
				logo
				echo -e "${yellow}  nodejs was not installed do you want to install it [y/n]\n"
				read -p "  >> " lk
				if [ "$lk" = "y" ];then
					apt install nodejs -y
					if [ "$?" == "0" ];then
						get_node_input
						start_node
					else
						clear
						logo
						echo -e "${yellow}  error while installing, try again"
						sleep 2
					fi
				fi
			  fi
			;;
			"3")
				if [ `dpkg -s python | grep -c "ok installed"` == "1" ];then
					if [ -z "$python_path" ] || [ -z "$python_port" ];then
						get_python_input
						start_python
					else
						start_python
					fi
				else
					logo
					echo -e "${yellow}  python was not installed do you want to install it [y/n]\n"
					read -p "  >> " co
					if [ "$co" == "y" ];then
						apt install python -y
						if [ "$?" == "0" ];then
							get_python_input
							start_python
						else
							clear
							logo
					        echo -e "${yellow}  error while installing, try again"
							sleep 2
						fi
					fi
				fi
			;;
			"4")
				if [ `dpkg -s mariadb | grep -c "ok installed"` -eq "1" ];then
					mysql
				else
					logo
					echo -e "  ${yellow}mariadb was not installed do you want to install it [y/n]\n"
					read -p "  >> " ca
					if [ "$ca" == y ];then
						apt install mariadb -y
						if [ "$?" == "0" ];then
							mysql
						else
							clear
                   		    logo
                    	    echo -e "${yellow}  error while installing, try again"
  	                        sleep 2							
						fi
					fi
				fi
			;;
			"5")
				change
			;;
			"6")
				while [ true ];do
					logo
					echo -e "${purple}"
					echo -e "  this script was maded by Mohammad Mohammadi"
					echo -e "  from mouod group, big thanks from allah"
					echo -e "\n  [0]exit\n"
					read -p "  >> " ex
					if [ "$ex" == "0" ];then
						break
					fi
				done
			;;
			"0")
				exit
			;;
		esac
	done
	
}

function change
{
	while [ true ];do
		logo
		echo -e " ${yellow} please enter type of your server\n"
		echo "  [1]php server"
		echo -e "  [2]python server"
		echo -e "  [3]node.js server\n"
		read -p "  >> " a
			case "$a" in
				"1")
					get_php_input
					break
				;;
				"2")
					get_python_input
					break
				;;
				"3")
					get_node_input
					break
				;;
			esac
	done
}
function mysql
{
		logo
	    echo -e "${green}  type:                          mysql database"
	    echo "  address:                       localhost:3306"
	    echo "  ip:                            127.0.0.1:3306"
		echo "  username:                      admin"
		echo -e "  password:                      admin\n"
	    echo  -e "  ${red}[ CTRL-\\ to exit and stop server  ]" &
	   	mysqld --skip-grant-tables &> /dev/null 
}
function start_python
{
#   cp $HOME/.conf/index.html $HOME/.conf/logo.png
    logo
    echo -e "${green}  type:                          python server"
    echo "  root directory:                $python_path"
    echo "  address:                       localhost:$python_port"
    echo "  ip:                            127.0.0.1:$python_port"
    echo  -e "\n  ${red}[ CTRL-C to exit and stop server  ]" &
    pushd "$python_path" > /dev/null; python -m http.server "$python_port" > /dev/null
}
function start_php
{
#	cp $HOME/.conf/index.html $HOME/.conf/logo.png
	logo
	echo -e "${green}  type:                          php server"
	echo "  root directory:                $php_path"
	echo "  address:                       localhost:$php_port"
	echo "  ip:                            127.0.0.1:$php_port"
	echo  -e "\n  ${red}[ CTRL-C to exit and stop server  ]" &
	php -S localhost:$php_port -t $php_path > /dev/null
}

function start_node
{
	logo
	echo -e "${green}  please wait...(mybe about 2m)"
	echo -e "${green}  unlike others servers you must wait..."
	echo -e "${red}  [ CTRL-C to exit and stop server ]"
	pushd "$node_path" > /dev/null ; npx http-server -p "$node_port" 
}

function get_php_input
{
	logo 
	echo -e "${yellow}"
	echo -e "  please enter your root directory(for example: /storage/server)\n"
	read -p "  >> " php_path
	while [ true ];do
		if [ -d "$php_path" ];then
			if [ ! -d "$HOME/.conf" ];then
				mkdir "$HOME/.conf"
			fi
			echo "$php_path" > "$HOME/.conf/php-path.txt"
	        cp $HOME/.conf/index.html $HOME/.conf/logo.png $php_path &> /dev/null
			break
		else
			logo
			echo -e "${red}"
			echo -e "  this directory is not existed! try another durectory\n"
			read -p "  >> " php_path
		fi
	done
		logo
		echo -e "${yellow}"
		echo -e "  Please enter a port(default is 8080)\n"
		read -p "  >> " php_port
		while [ true ];do
		if [ "$php_port" == "" ];then
			php_port="8080"
			echo "$php_port" > "$HOME/.conf/php-port.txt"
			break
		elif [[ "$php_port" =~ ^[0-9]*$ ]] && [ $php_port -ge 1024 ] && [ $php_port -le 65535 ];then
			echo "$php_port" > "$HOME/.conf/php-port.txt"
			break
		else
			logo
			echo -e "${red}"
			echo -e "  invalid port(port must be between 1024 < x < 65535) try again!\n"
			read -p "  >> " php_port
		fi
	done
}

function get_python_input
{
    logo
    echo -e "${yellow}"
    echo -e "  please enter your root directory(for example: /storage/server)\n"
    read -p "  >> " python_path
    while [ true ];do
        if [ -d "$python_path" ];then
            if [ ! -d "$HOME/.conf" ];then
                mkdir "$HOME/.conf"
            fi
            echo "$python_path" > "$HOME/.conf/python-path.txt"
            cp $HOME/.conf/index.html $HOME/.conf/logo.png $python_path &> /dev/null
            break
        else
            logo
            echo -e "${red}"
            echo -e "  this directory is not existed! try another durectory\n"
            read -p "  >> " python_path
        fi
    done
        logo
        echo -e "${yellow}"
        echo -e "  Please enter a port(default is 8080)\n"
        read -p "  >> " python_port
        while [ true ];do
        if [ "$python_port" == "" ];then
            python_port="8080"
            echo "$python_port" > "$HOME/.conf/python-port.txt"
            break
        elif [[ "$python_port" =~ ^[0-9]*$ ]] && [ $python_port -ge 1024 ] && [ $python_port -le 65535 ];then
            echo "$python_port" > "$HOME/.conf/python-port.txt"
            break
        else
            logo
            echo -e "${red}"
            echo -e "  invalid port(port must be between 1024 < x < 65535) try again!\n"
            read -p "  >> " python_port
        fi
    done
}

function get_node_input
{
    logo
    echo -e "${yellow}"
    echo -e "  please enter your root directory(for example: /storage/server)\n"
    read -p "  >> " node_path
    while [ true ];do
        if [ -d "$node_path" ];then
            if [ ! -d "$HOME/.conf" ];then
                mkdir "$HOME/.conf"
            fi
            echo "$node_path" > "$HOME/.conf/node-path.txt"
            cp $HOME/.conf/index.html $HOME/.conf/logo.png $node_path &> /dev/null
            break
        else
            logo
            echo -e "${red}"
            echo -e "  this directory is not existed! try another durectory\n"
            read -p "  >> " node_path
        fi
    done
        logo
        echo -e "${yellow}"
        echo -e "  Please enter a port(default is 8080)\n"
        read -p "  >> " node_port
        while [ true ];do
        if [ "$node_port" == "" ];then
            node_port="8080"
            echo "$node_port" > "$HOME/.conf/node-port.txt"
            break
        elif [[ "$node_port" =~ ^[0-9]*$ ]] && [ $node_port -ge 1024 ] && [ $node_port -le 65535 ];then
            echo "$node_port" > "$HOME/.conf/node-port.txt"
            break
        else
            logo
            echo -e "${red}"
            echo -e "  invalid port(port must be between 1024 < x < 65535) try again!\n"
            read -p "  >> " node_port
        fi
    done
}
########################  Varibles  #########################

red="\033[0;31m"
nc="\033[0m"
yellow="\033[1;31m"
green="\033[1;32m"
purple="\033[1;35m"
php_path=`cat "$HOME/.conf/php-path.txt"`
php_port=`cat "$HOME/.conf/php-port.txt"`
python_path=`cat "$HOME/.conf/python-path.txt"`
python_port=`cat "$HOME/.conf/python-port.txt"`
node_path=`cat "$HOME/.conf/node-path.txt"`
#node_port=`cat "$HOME/.conf/node-port.txt"`

#############################################################
if [ ! -d "$HOME/.conf" ];then
	mkdir "$HOME/.conf"
fi
if [ ! -f "$HOME/.conf/index.html" ] || [ ! -f "$HOME/.conf/logo.png" ];then
	cp index.html logo.png $HOME/.conf
fi
main