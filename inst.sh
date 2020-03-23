#!/bin/sh

printf "\n\n [?] Survey has been started\n\n\n"

read -p "What is your nickname?: " nick
read -p "Do you want to install tools? (yes/no): " stools
read -p "Do you want to download libraries? (yes/no): " libs
read -p "Do you want to install suckless utilities? (yes/no): " sless
if [ "$sless" = "yes" ]; then
        read -p "What gap size do you want in DWM? (num): " gappx
read -p "Do you want to install TOR browser? (yes/no): " torb
read -p "Do you want to install Python? (yes/no): " python
if [ "$python" = "yes" ]; then
	read -p "Install or compile Python? 0 or 1?: " icp
fi
read -p "Do you want to install VIM as Python IDE? (yes/no): " vim
if [ "$vim" = "yes" ]; then
	read -p "Install or compile VIM? 0 or 1?: " icv
fi

printf "\n\n [.] Survey has been ended\n\n\n"

if [ "$stools" = "yes" ]; then
	sed -i '7c deb http://deb.debian.org/debian/ buster main contrib non-free' /etc/apt/sources.list
	sed -i '8c deb-src http://deb.debian.org/debian/ buster main contrib non-free' /etc/apt/sources.list
	sed -i '15a deb http://deb.debian.org/debian buster-backports main contrib non-free' /etc/apt/sources.list
	apt update -y
	apt upgrade -y
	apt install build-essential lightdm lightdm-gtk-greeter-settings nvidia-driver nvidia-smi nvidia-xconfig nvidia-cuda-toolkit ocl-icd-libopencl1 net-tools zsh tmux git info neofetch -y
	apt install htop glances strace psmisc simple-scan curl wget lsof tree exiftool -y
	apt install ffmpeg shntool feh sxiv mpv gimp imagemagick jpegoptim zathura -y
	apt install adb fastboot transmission gmtp bleachbit redshift flameshot -y
	mkdir /home/$nick/inst
	cd /home/$nick/inst
	wget https://github.com/gokcehan/lf/releases/download/r13/lf-linux-amd64.tar.gz
	git clone --depth 1 https://github.com/cjbassi/gotop /tmp/gotop_dir
	/tmp/gotop_dir/scripts/download.sh
	tar xvf lf-linux-amd64.tar.gz
	rm -rf /usr/bin/lf /usr/bin/gotop
	mv -v lf /usr/bin
	mv -v gotop /usr/bin
	chmod 755 /usr/bin/lf /usr/bin/gotop
	chown root:root /usr/bin/lf /usr/bin/gotop
	rm -rf lf* /tmp/gotop_dir
fi

if [ "$libs" = "yes" ]; then
	rm -rf /home/"$nick"/LIBS
	cd /home/"nick"/LIBS
	wget https://bootstrap.pypa.io/get-pip.py
	wget https://developer.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda_10.1.105_418.39_linux.run
	#wget https://bitbucket.org/pypy/pypy/downloads/pypy3.6-v7.3.0-linux64.tar.bz2
	#rm -rf /opt/pypy3 /usr/local/bin/pypy3 /usr/bin/pypy3
	#tar -x -C /opt -f pypy3.6-v7.3.0-linux64.tar.bz2
	#rm -rf pypy3.6-v7.3.0-linux64.tar.bz2
	#mv /opt/pypy3.6-v7.3.0-linux64 /opt/pypy3
	#ln -s /opt/pypy3/bin/pypy3 /usr/local/bin/pypy3
	#ln -s /opt/pypy3/bin/pypy3 /usr/bin/pypy3

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
	apt install zlib1g-dev libcap-dev libexpat-dev libssl-dev -y
	if [ "$icp" = 0 ]; then
		rm -rf /usr/bin/lsb_release
		apt install python2.7-dev python3.7-dev -y
	elif [ "$icp" = 1 ]; then
		apt install libbz2-dev liblzma-dev libncurses5-dev libncursesw5-dev libgdbm-dev libnss3-dev libreadline-dev libffi-dev tk-dev libsqlite3-dev -y
		wget https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tar.xz
		tar xvf Python-3.8.2.tar.xz
		cd Python-3.8.2
		./configure --prefix=/usr --enable-loadable-sqlite-extensions --enable-shared --with-lto --enable-optimizations --enable-ipv6 --with-pydebug
		make -j$(nproc)
		make altinstall
		cd ..
		rm -rf Python-3.8.2*
	fi
fi

if [ "$vim" = "yes" ]; then
	rm -rf /home/$nick/.vim
	mkdir -p /home/$nick/.vim/autoload
	cd /home/$nick/.vim/autoload
	wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	chown -R $nick:$nick /home/$nick/.vim
	if [ "$icv" = 0 ]; then
		apt install vim -y
	elif [ "$icv" = 1 ]; then
		git clone https://github.com/vim/vim.git
		cd vim
		./configure --prefix=/usr --with-features=huge --enable-pythoninterp --enable-optimizations
		make -j$(nproc)
		make install
		cd ..
		rm -rf vim
	fi
fi

if [ "$stools" = "yes" ]; then
	rm -rf /home/$nick/.oh-my-zsh
	rm -rf /home/$nick/.zshrc
	echo "Copy all your configs now to home directory"
fi

apt update -y
apt upgrade -y

echo 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
echo 'nvidia-xconfid --cool-bits=4'
