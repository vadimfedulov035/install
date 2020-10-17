#!/bin/sh

printf "\n\n [!] ATOIC\n        When time matters\n\n\n"

read -p "What is your nickname?: " nick

read -p "Do you want to install GCC? (yes/no): " gtools
read -p "Do you want to install standard tools? (yes/no): " stools
read -p "Do you want to download additional libraries? (yes/no): " libs
read -p "Do you want to install suckless utilities? (yes/no): " sless
[ "$sless" = "yes" ] && read -p "What gap size do you want in DWM? (num): " gappx
read -p "Do you want to install TOR browser? (yes/no): " torb
read -p "Do you want to install Python? (yes/no): " py
[ "$py" = "yes" ] && read -p "Install or compile Python? 0 or 1?: " pyc
read -p "Do you want to install VIM as C/C++/Python IDE? (yes/no): " vim
[ "$vim" = "yes" ] && read -p "Install or compile VIM? 0 or 1?: " vimc

if [ "$gtools" = "yes" ]; then
	read -p "Install standard or compile recent GCC? 0 or 1?: " gtoolsc
	if [ "$gtoolsc" = 0 ]; then
		apt install build-essential -y  # install default build-pack
	elif [ "$gtoolsc" = 1 ]; then
		wget https://ftpmirror.gnu.org/gcc/gcc-10.2.0/gcc-10.2.0.tar.gz && tar xvf gcc-10.2.0.tar.gz && cd gcc-10.2.0  # download, untar archive; go to dir
		contrib/download_prerequisites  # download prerequisites
		mkdir ../build && cd ../build  # make dir; go dir
		../gcc-10.2.0/configure -v --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu --prefix=/usr --enable-checking=release --enable-languages=c,c++ --disable-multilib --program-suffix=-10.2
		make -j && make install-strip  # compile compiler and install
		rm -rf /usr/bin/gcc && ln -s /usr/bin/gcc-10.2 /usr/bin/gcc  # make gcc-10.2 default system compiler
		cd ..
		rm -rf gcc* build
	fi
fi

if [ "$stools" = "yes" ]; then
	sed -i '7c deb http://deb.debian.org/debian/ buster main contrib non-free' /etc/apt/sources.list
	sed -i '8c deb-src http://deb.debian.org/debian/ buster main contrib non-free' /etc/apt/sources.list
	sed -i '16c deb http://deb.debian.org/debian buster-backports main contrib non-free' /etc/apt/sources.list
	apt update -y  # update everything
	apt upgrade -y  # upgrade everything
	apt install xorg xorg-dev lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings xwallpaper thunar nvidia-driver nvidia-smi nvidia-xconfig nvidia-cuda-toolkit ocl-icd-libopencl1 -y  # download all GPU/X11 related stuff
	apt install zsh tmux net-tools info htop glances strace psmisc sxhkd curl lsof tree exiftool neofetch -y  # download programs for operating the system
	apt install firefox-esr pulseaudio pulsemixer ffmpeg shntool feh sxiv mpv gimp imagemagick jpegoptim zathura -y  # download programs for working with media
	apt install keepassxc adb fastboot transmission gmtp bleachbit redshift flameshot -y  # download programs for working with other devices and keeping system safe
	wget https://github.com/gokcehan/lf/releases/download/r13/lf-linux-amd64.tar.gz && tar xvf lf-linux-amd64.tar.gz && mv -v lf /usr/bin  # download, untar archive; install file manager
	wget https://github.com/cjbassi/ytop/releases/download/0.6.1/ytop-0.6.1-x86_64-unknown-linux-gnu.tar.gz && tar xvf ytop-0.6.1*.tar.gz && mv -v ytop /usr/bin  # download, untar archive; install observing program
	chmod 755 /usr/bin/lf && chown root:root /usr/bin/lf  # change permissions to needed
	rm -rf lf* ytop*
fi

if [ "$libs" = "yes" ]; then
	mkdir /home/$nick/libs
	wget https://bootstrap.pypa.io/get-pip.py -O /home/$nick/libs/get-pip.py  # download get-pip.py
	wget https://developer.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda_10.1.105_418.39_linux.run -O /home/$nick/libs/cuda_10.1.run  # download latest compatible CUDA
fi

if [ "$sless" = "yes" ]; then
	apt install compton libharfbuzz-dev libxinerama-dev -y  # install needed prerequisites
	### DWM ###
	wget https://dl.suckless.org/dwm/dwm-6.2.tar.gz && tar xvf dwm-6.2.tar.gz && cd dwm-6.2  # download, untar archive; go to dir
	wget https://dwm.suckless.org/patches/fullgaps/dwm-fullgaps-6.2.diff && patch < dwm-fullgaps-6.2.diff  # apply first patch
	wget https://dwm.suckless.org/patches/fakefullscreen/dwm-fakefullscreen-20170508-ceac8c9.diff && patch < dwm-fakefullscreen-20170508-ceac8c9.diff  # apply second patch
	make -j  # compile
	sed -i "5c static const unsigned int gappx     = $gappx;        /* gaps between windows */"  # set gapp
	sed -i "48c \#define MODKEY Mod4Mask" config.h  # change MODKEY for Windows
	make install  # install
	cd ..
	### ST ###
	git clone https://github.com/lukesmithxyz/st && cd st  # download; go to dir
	make -j && make install  # install
	cd ..
	rm -rf dwm* st
fi

if [ "$torb" = "yes" ]; then
	apt install tor libdbus-glib-1-2 -y  # install needed prerequisites
	wget https://www.torproject.org/dist/torbrowser/10.0.1/tor-browser-linux64-10.0.1_en-US.tar.xz && tar xvf tor-browser-linux64-10.0.1_en-US.tar.xz  # download, untar archive; 
	mv -v tor-browser_en-US /home/$nick/.browser
	chmod -R 755 /home/$nick/.browser && chown -R $nick:$nick /home/$nick/.browser  # change permissions
	rm -rf tor*
fi

if [ "$py" = "yes" ]; then
	if [ "$pyc" = 0 ]; then
		apt install python2.7-dev python3.7-dev -y  # install default python2 python3
	elif [ "$pyc" = 1 ]; then
		apt install zlib1g-dev libbz2-dev liblzma-dev libncurses5-dev libgdbm-dev libssl-dev libnss3-dev libreadline-dev libffi-dev tk-dev libsqlite3-dev -y  # install prerequisites
		wget https://www.python.org/ftp/python/3.9.0/Python-3.9.0.tar.xz && tar xvf Python-3.9.0.tar.xz && cd Python-3.9.0  # download, untar archive; go to dir
		./configure --prefix=/usr --enable-loadable-sqlite-extensions --enable-shared --enable-optimizations --with-lto --enable-ipv6 --with-pydebug
		make -j && make altinstall  # install
		cd ..
		rm -rf Python*
	fi
fi

if [ "$vim" = "yes" ]; then
	mkdir -p /home/$nick/.vim/autoload  # make dir
	wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -O /home/$nick/.vim/autoload/plug.vim
	chown -R $nick:$nick /home/$nick/.vim  # change permissions
	if [ "$vimc" = 0 ]; then
		apt install vim -y  # install default vim
	elif [ "$vimc" = 1 ]; then
		git clone https://github.com/vim/vim.git && cd vim  # download; go to dir
		./configure --prefix=/usr --with-features=huge --enable-pythoninterp --enable-optimizations
		make -j && make install  # install
		cd ..
		rm -rf vim
	fi
fi

nvidia-xconfig --cool-bits=4  # activate NVIDIA FAN control

cp -v Xsession /home/$nick/.Xsession
cp -v Xdefaults /home/$nick/.Xdefaults
cp -v tmux.conf /home/$nick/.tmux.conf  # need to put sxhkd.conf to .config directory
[ "$vim" = "yes" ] && cp -v vimrc /home/$nick/.vim

apt update -y  # update
apt upgrade -y  # upgrade
