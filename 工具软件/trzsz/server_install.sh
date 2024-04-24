version="1.1.7"
wget https://mirror.ghproxy.com/https://github.com/trzsz/trzsz-go/releases/download/v${version}/trzsz_${version}_linux_x86_64.tar.gz
tar -zxvf trzsz_${version}_linux_x86_64.tar.gz
cd trzsz_${version}_linux_x86_64
chmod +x trzsz tsz trz
mv ./* /usr/local/bin/
rm -rf trzsz_${version}_linux_x86_64.tar.gz trzsz_${version}_linux_x86_64