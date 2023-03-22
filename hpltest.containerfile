FROM registry.suse.com/bci/bci-base
RUN zypper -q install -y gcc git
USER unpriv
mkdir ~/src
cd ~/src
git clone https://github.com/spack/spack.git
