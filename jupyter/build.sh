#!/bin/sh

echo "Installing Dependencies"
apt update >/dev/null 2>&1
apt remove libgl1 >/dev/null 2>&1 && apt autoremove >/dev/null 2>&1
apt install autopoint asciidoc bsdtar build-essential dosfstools fakeroot flex git gnulib gnutls-bin help2man intltool libgpgme11 libtool m4 make meson mtools shellcheck squashfs-tools texinfo xorriso zstd erofs-utils grub-common dosfstools mtools cryptsetup >/dev/null 2>&1
apt-get --no-install-recommends install asciidoc -y > /dev/null 2>&1
#pip install --upgrade --force meson ninja >/dev/null 2>&1


echo "install gettext"
  # !rm -rf gettext-0.21
wget https://ftp.gnu.org/gnu/gettext/gettext-0.21.tar.xz >/dev/null 2>&1
tar xf gettext-0.21.tar.xz >/dev/null 2>&1
cd gettext-0.21 && autoreconf -i >/dev/null 2>&1
./configure --prefix=/usr >/dev/null 2>&1
make >/dev/null 2>&1
sudo DISTDIR="/" make install >/dev/null 2>&1
cd ..

echo "install autoconf"
git clone https://git.savannah.gnu.org/git/autoconf.git autoconf-git >/dev/null 2>&1
cd autoconf-git && autoreconf -i >/dev/null 2>&1
./configure --prefix=/usr >/dev/null 2>&1
make >/dev/null 2>&1
sudo DESTDIR="/" make install >/dev/null 2>&1
cd ..

echo "install cmake"
  #!rm -rf cmake-3.23.2
apt remove cmake >/dev/null 2>&1
wget https://github.com/Kitware/CMake/releases/download/v3.23.2/cmake-3.23.2.tar.gz >/dev/null 2>&1
tar xf cmake-3.23.2.tar.gz
cd cmake-3.23.2 && ./configure --prefix=/usr >/dev/null 2>&1
make >/dev/null 2>&1
sudo make install >/dev/null 2>&1
cd ..

echo "install ntph"
wget https://gnupg.org/ftp/gcrypt/npth/npth-1.6.tar.bz2 >/dev/null 2>&1
tar xf npth-1.6.tar.bz2
cd npth-1.6 && ./configure --prefix=/usr >/dev/null 2>&1
make >/dev/null 2>&1
sudo make install >/dev/null 2>&1
cd ..

def install_gcrypt():
echo "install gcrypt"
wget https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.10.1.tar.bz2 >/dev/null 2>&1
tar xf libgcrypt-1.10.1.tar.bz2
cd libgcrypt-1.10.1 && ./configure --prefix=/usr
make
sudo make install
cd ..

echo "install gpg"
rm -rf gnupg-2.3.6
apt install libksba-dev libgnutls28-dev
wget https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.3.6.tar.bz2 >/dev/null 2>&1
tar xf gnupg-2.3.6.tar.bz2
cd gnupg-2.3.6 && ./configure --prefix=/usr --disable-gpg-test >/dev/null 2>&1
make >/dev/null 2>&1
sudo make install >/dev/null 2>&1
cd ..

echo "install libassuan"
rm -rf libassuan-2.5.5
wget https://gnupg.org/ftp/gcrypt/libassuan/libassuan-2.5.5.tar.bz2 >/dev/null 2>&1
tar xf libassuan-2.5.5.tar.bz2
cd libassuan-2.5.5 && ./configure --prefix=/usr >/dev/null 2>&1
make >/dev/null 2>&1
sudo make install >/dev/null 2>&1
cd ..

echo "install gpgme-error"
  # !rm -rf libgpg-error-1.31
  #!apt install libassuan-dev
wget https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.31.tar.bz2 >/dev/null 2>&1
tar xf libgpg-error-1.31.tar.bz2
cd libgpg-error-1.31 && ./configure --prefix=/usr >/dev/null 2>&1
make >/dev/null 2>&1
sudo make install >/dev/null 2>&1
cd ..
cp /usr/lib/libgpg-error* /usr/lib/x86_64-linux-gnu


echo "install gpgme 1.13.1"
  #!apt install libgpgme-dev
apt remove libgpg-error-dev >/dev/null 2>&1
rm -rf gpgme-1.13.1
apt install libassuan-dev >/dev/null 2>&1
wget https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.13.1.tar.bz2
tar xf gpgme-1.13.1.tar.bz2
cd gpgme-1.13.1 && ./configure --prefix=/usr --disable-gpg-test --enable-languages="cl cpp" --disable-fd-passing --disable-gpgsm-test >/dev/null 2>&1
make >/dev/null 2>&1
sudo make install >/dev/null 2>&1
cd ..

echo "install zstd"
apt remove libzstd-dev >/dev/null 2>&1
rm -rf /usr/lib/libzstd*
rm -rf /usr/bin/zstd*
rm -rf /usr/include/libzstd*
rm -rf /usr/include/zstd*
rm -rf zstd-1.5.2
wget https://github.com/facebook/zstd/releases/download/v1.5.2/zstd-1.5.2.tar.gz >/dev/null 2>&1
tar -xf zstd-1.5.2.tar.gz
cd zstd-1.5.2 && sed '/build static library to build tests/d' -i build/cmake/CMakeLists.txt
sed 's/libzstd_static/libzstd_shared/g' -i build/cmake/tests/CMakeLists.txt
CFLAGS+=' -ffat-lto-objects' CXXFLAGS+=' -ffat-lto-objects' cmake -S build/cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=None -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib/x86_64-linux-gnu -DZSTD_BUILD_CONTRIB=ON -DZSTD_BUILD_STATIC=ON -DZSTD_BUILD_TESTS=OFF -DZSTD_PROGRAMS_LINK_SHARED=ON >/dev/null 2>&1
echo "build"
cmake --build build >/dev/null 2>&1
DISTDIR="" cmake --install build >/dev/null 2>&1
ln -sf /usr/bin/zstd "/usr/bin/zstdmt"
cd ..

  # !rm -rf tar-1.34
wget https://ftp.gnu.org/gnu/tar/tar-1.34.tar.xz >/dev/null 2>&1
tar -xf tar-1.34.tar.xz >/dev/null 2>&1
cd tar-1.34 && FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr >/dev/null 2>&1
make >/dev/null 2>&1
DESTDIR="/" make install >/dev/null 2>&1
cd ..

  # !rm -rf libarchive-3.6.1
echo "install libarchive 3.6.1"
wget https://github.com/libarchive/libarchive/releases/download/v3.6.1/libarchive-3.6.1.tar.xz >/dev/null 2>&1
tar xf libarchive-3.6.1.tar.xz
cd libarchive-3.6.1 && cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr >/dev/null 2>&1
echo "build"
cmake --build build >/dev/null 2>&1
echo "install"
sudo cmake --install build >/dev/null 2>&1
cd ..

print("install pacman")
# !rm -rf pacman
mkdir /etc/pacman.d
git clone https://gitlab.archlinux.org/tallero/archiso archiso >/dev/null 2>&1
git clone https://gitlab.archlinux.org/pacman/pacman >/dev/null 2>&1
  
cd pacman && meson --prefix=/usr --buildtype=plain -Dgpgme=enabled -Ddoc=disabled -Ddoxygen=disabled -Dscriptlet-shell=/usr/bin/bash -Dldconfig=/usr/bin/ldconfig build #>/dev/null 2>&1
meson compile -C build #>/dev/null 2>&1
sudo DESTDIR="/" meson install -C build #>/dev/null 2>&1
sudo install -dm755 "/etc" >/dev/null 2&1
sudo install -m644 "build/pacman.conf" "/etc" >/dev/null 2>&1
sudo install -m644 "build/makepkg.conf" "/etc" >/dev/null 2>&1
cd ..
echo "Server = https://geo.mirror.pkgbuild.com/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist
sudo cp archiso/configs/releng/pacman.conf /etc/pacman.conf
sudo pacman-key --init archlinux
sudo pacman -Sy


  # !rm -rf archiso-install-scripts
git clone https://github.com/archlinux/arch-install-scripts >/dev/null 2>&1
make -C arch-install-scripts > /dev/null 2>&1
sudo make -C arch-install-scripts PREFIX=/usr DESTDIR="/" install > /dev/null 2>&1

# !rm -rf archiso
git clone https://gitlab.archlinux.org/tallero/archiso archiso-encryption >/dev/null 2>&1
git checkout -C archiso -b crypto >/dev/null 2>&1
cd archiso-encryption && make -k check >/dev/null 2>&1
make DESTDIR="/" install >/dev/null 2>&1
cd ..

echo "install grub-pc"
apt install libfuse-dev >/dev/null 2>&1
rm -rf grub-2.06
wget https://ftp.gnu.org/gnu/grub/grub-2.06.tar.xz >/dev/null 2>&1
tar xf grub-2.06.tar.xz
cd grub-2.06 && ./configure --prefix=/usr --with-platform="pc" --target i386 --enable-efiemu	--enable-mm-debug --enable-nls --enable-device-mapper --enable-cache-stats --enable-grub-mkfont --enable-grub-mount --prefix="/usr" --bindir="/usr/bin" --sbindir="/usr/bin" --mandir="/usr/share/man" --infodir="/usr/share/info" --datarootdir="/usr/share" --sysconfdir="/etc" --program-prefix="" --with-bootdir="/boot" --with-grubdir="grub" --disable-silent-rules --disable-werror >/dev/null 2>&1
make >/dev/null 2>&1
DESTDIR="/" PREFIX="/usr" sudo make install >/dev/null 2>&1
cd ..
echo "install grub-efi-pc"
rm -rf grub-2.06
tar xf grub-2.06.tar.xz >/dev/null 2>&1
cd grub-2.06 && ./configure --prefix=/usr --with-platform="efi" --target i386--enable-mm-debug --enable-nls --enable-device-mapper --enable-cache-stats --enable-grub-mkfont --enable-grub-mount --prefix="/usr" --bindir="/usr/bin" --sbindir="/usr/bin" --mandir="/usr/share/man" --infodir="/usr/share/info" --datarootdir="/usr/share" --sysconfdir="/etc" --program-prefix="" --with-bootdir="/boot" --with-grubdir="grub" --disable-silent-rules --disable-werror >/dev/null 2>&1
make >/dev/null 2>&1
DESTDIR="/" PREFIX="/usr" sudo make install >/dev/null 2>&1
cd ..

echo "install grub-efi-x86_64"
rm -rf grub-2.06
tar xf grub-2.06.tar.xz
cd grub-2.06 &&  ./configure --prefix=/usr --with-platform="efi" --target x86_64	--enable-mm-debug --enable-nls --enable-device-mapper --enable-cache-stats --enable-grub-mkfont --enable-grub-mount --prefix="/usr" --bindir="/usr/bin" --sbindir="/usr/bin" --mandir="/usr/share/man" --infodir="/usr/share/info" --datarootdir="/usr/share" --sysconfdir="/etc" --program-prefix="" --with-bootdir="/boot" --with-grubdir="grub" --disable-silent-rules --disable-werror >/dev/null 2>&1
make >/dev/null 2>&1
DESTDIR="/" PREFIX="/usr" sudo make install >/dev/null 2>&1
wget https://raw.githubusercontent.com/archlinux/svntogit-packages/packages/grub/trunk/sbat.csv
sed -e "s/%PKGVER%/2.06/" < "sbat.csv" > "/usr/share/grub/sbat.csv"
cd ..

echo "install xorriso"
  # !rm -rf libisofs libburn libisoburn
wget https://files.libburnia-project.org/releases/libisofs-1.5.4.tar.gz >/dev/null 2>&1
tar xf libisofs-1.5.4.tar.gz
cd libisofs-1.5.4 && ./configure --prefix=/usr >/dev/null 2>&1
make >/dev/null 2>&1
DESTDIR="/" sudo make install >/dev/null 2>&1
cd ..
wget https://files.libburnia-project.org/releases/libburn-1.5.4.tar.gz >/dev/null 2>&1
tar xf libburn-1.5.4.tar.gz
cd libburn-1.5.4 && ./configure --prefix=/usr >/dev/null 2>&1
make >/dev/null 2>&1
DESTDIR="/" sudo make install >/dev/null 2>&1
cd ..
wget https://files.libburnia-project.org/releases/libisoburn-1.5.4.tar.gz
tar xf libisoburn-1.5.4.tar.gz
cd libisoburn-1.5.4 && ./configure --prefix=/usr >/dev/null 2>&1
&& make >/dev/null 2>&1
DESTDIR="/" sudo make install >/dev/null 2>&1
cd ..
echo "install asp"
  # !rm -rf asp
git clone https://github.com/falconindy/asp.git >/dev/null 2>&1
make -C asp >/dev/null 2&1
sudo make -C asp PREFIX=/usr DESTDIR="" install >/dev/null 2>&1
sudo install -Dm644 asp/LICENSE "/usr/share/licenses/asp/LICENSE" >/dev/null 2>&1

echo "install reflector"
  # !rm -rf reflector
git clone https://gitlab.archlinux.org/tallero/reflector
cd reflector && python3 setup.py install --prefix=/usr --root="/" --optimize=1
install -Dm644 "man/reflector.1.gz" "/usr/share/man/man1/reflector.1.gz"
install -Dm644 'reflector.service' "/usr/lib/systemd/system/reflector.service"
install -Dm644 'reflector.timer' "/usr/lib/systemd/system/reflector.timer"
install -Dm644 'reflector.conf' "/etc/xdg/reflector/reflector.conf"
cd ..

echo "build releng"
cd archiso/configs/releng && rm -rf work out
cd /content/archiso-profiles-vk/jupyter
cd archiso/configs/releng && mkarchiso -v .

# !rm -rf archiso-profiles >/dev/null 2>&1
#git clone https://gitlab.archlinux.org/tallero/archiso-profiles >/dev/null 2>&1
#useradd user >/dev/null 2>&1
#chown -R user:user archiso-profiles /tmp
#su user -c "cd archiso-profiles/ereleng && bash build_repo.sh"
#!cd archiso-profiles/desktop && bash build_repo.sh


