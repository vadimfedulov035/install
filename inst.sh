#!/bin/sh

printf "\n\n [?] Survey has been started\n\n\n"

read -p "What is your nickname?: " nick
read -p "Do you want to install tools and libraries? (yes/no): " stools
read -p "Do you want to install DWM and ST? (yes/no): " sless
if [ "$sless" = "yes" ]; then
	read -p "What gap size for DWM do you want?: " gappx
fi
read -p "Do you want to install TOR browser? (yes/no): " torb
read -p "Do you want to install Python? (yes/no): " python
read -p "Do you want to install VIM as Python IDE? (yes/no): " vim

printf "\n\n [.] Survey has been ended\n\n\n"

if [ "$stools" = "yes" ]; then
	sed -i '7c deb http://deb.debian.org/debian/ buster main contrib non-free' /etc/apt/sources.list
	sed -i '8c deb-src http://deb.debian.org/debian/ buster main contrib non-free' /etc/apt/sources.list
	apt update -y
	apt upgrade -y
	apt install lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings nvidia-driver nvidia-smi gnome-themes-standard libx11-dev libxinerama-dev libncurses-dev libxft-dev zsh info git thunar htop glances strace dmenu dosfstools neofetch pcregrep curl wget lsof tree ffmpeg shntool sxiv feh mpv gimp imagemagick jpegoptim zathura kid3 gmtp bleachbit wipe sxhkd redshift flameshot adb fastboot firefox-esr transmission libreoffice simple-scan pulseaudio pulsemixer cowsay fortune -y
	mkdir /home/$nick/.nvidia
	cd /home/$nick/.nvidia
	wget https://developer.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda_10.1.105_418.39_linux.run
	wget https://github.com/gokcehan/lf/releases/download/r13/lf-linux-amd64.tar.gz
	git clone --depth 1 https://github.com/cjbassi/gotop /tmp/gotop_dir
	/tmp/gotop_dir/scripts/download.sh
	tar xvf lf-linux-amd64.tar.gz
	rm -rf /usr/bin/lf
	rm -rf /usr/bin/gotop
	mv -v lf /usr/bin
	mv -v gotop /usr/bin
	chmod 755 /usr/bin/lf /usr/bin/gotop
	chown root:root /usr/bin/lf /usr/bin/gotop
	rm -rf lf* /tmp/gotop_dir
fi

if [ "$sless" = "yes" ]; then
	apt install build-essential compton -y
	wget https://dl.suckless.org/dwm/dwm-6.2.tar.gz
	git clone https://github.com/lukesmithxyz/st
	tar xvf dwm-6.2.tar.gz
	cd dwm-6.2
	wget https://dwm.suckless.org/patches/fullgaps/dwm-fullgaps-6.2.diff
	wget https://dwm.suckless.org/patches/fakefullscreen/dwm-fakefullscreen-20170508-ceac8c9.diff
	patch < dwm-fullgaps-6.2.diff
	patch < dwm-fakefullscreen-20170508-ceac8c9.diff
	rm *.diff
	make -j$(nproc)
	sed -i "5c static const unsigned int gappx     = $gappx;        /* gaps between windows */"
	sed -i "48c \#define MODKEY Mod4Mask" config.h
	make install
	cd ../st
	make -j$(nproc)
	make install
	cd ..
	rm -r st dwm*
fi

if [ "$torb" = "yes" ]; then
	apt install tor libdbus-glib-1-2 -y
	wget https://www.torproject.org/dist/torbrowser/9.0.4/tor-browser-linux64-9.0.4_en-US.tar.xz
	tar xvf tor-browser-linux64-9.0.4_en-US.tar.xz
	rm -rf /home/$nick/.browser
	mv -v tor-browser_en-US /home/$nick/.browser
	chmod -R 755 /home/$nick/.browser
	chown -R $nick:$nick /home/$nick/.browser
	rm tor-browser*
fi

if [ "$python" = "yes" ]; then
	read -p 'Do you want to compile Python or install from repository? (comp/inst): ' pci
	if [ "$pci" = "comp" ]; then
		apt install build-essential zlib1g-dev libbz2-dev liblzma-dev llibssl-dev ibsqlite3-dev -y
		wget https://www.python.org/ftp/python/3.8.1/Python-3.8.1.tar.xz
		tar xvf Python-3.8.1.tar.xz
		cd Python-3.8.1
		./configure --prefix=/usr --enable-loadable-sqlite-extensions --enable-shared --with-lto --enable-optimizations --enable-ipv6 --with-pydebug
		make -j$(nproc)
		make install
		cd ..
		rm -rf Python-3.8.1*
		rm -rf /usr/bin/python3
		ln -s /usr/bin/python3.7 /usr/bin/python3
	elif [ "$pci" = "inst" ]; then
		apt install python3.7-dev -y
	else
		echo "Nothing has been chosen"
	fi
fi

if [ "$vim" = "yes" ]; then
	rm -rf /home/$nick/.vim
	mkdir -p /home/$nick/.vim/autoload
	cd /home/$nick/.vim/autoload
	wget curl https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	chown -R $nick:$nick /home/$nick/.vim
	read -p 'Do you want to compile Vim or install from repository? (comp/inst): ' vci
	if [ "$vci" = "comp" ]; then
		apt install build-essential -y
		git clone https://github.com/vim/vim.git
		cd vim
		./configure --prefix=/usr --with-features=huge --enable-pythoninterp
		make -j$(nproc)
		make install
		cd ..
		rm -rf vim
	elif [ "$vci" = "inst" ]; then
		apt install vim
	else
		echo "Nothing has been chosen"
	fi
fi

if [ "$stools" = "yes" ]; then
	rm -rf /home/$nick/.oh-my-zsh
	rm -rf /home/$nick/.zshrc
	echo "Copy all your configs now to home directory"
fi

apt update -y
apt upgrade -y


# sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# wget https://bootstrap.pypa.io/get-pip.py
