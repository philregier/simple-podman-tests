FROM registry.suse.com/bci/bci-base
RUN zypper addrepo https://download.opensuse.org/repositories/network:/cluster/SLE_15_SP4/network:cluster.repo
RUN zypper --gpg-auto-import-keys -q install --no-recommends -y gcc git spack
RUN useradd -m unpriv
USER unpriv
RUN mkdir $HOME/src
WORKDIR $HOME/src
RUN git clone --depth 1 https://github.com/spack/spack.git
RUN pwd
WORKDIR $HOME/src/spack
RUN env
