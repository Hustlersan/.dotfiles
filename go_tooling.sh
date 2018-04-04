mkdir -p ~/go/{src,bin/pkg}
curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer | sh
gvm install go1.4 -B
gvm use go1.4
export GOROOT_BOOTSTRAP=$GOROOT
gvm install go1.10.1
gvm use go1.10.1 --default
gometalinter --install
