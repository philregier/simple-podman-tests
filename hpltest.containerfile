FROM registry.suse.com/bci/bci-base
RUN zypper addrepo https://download.opensuse.org/repositories/network:/cluster/SLE_15_SP4/network:cluster.repo
RUN zypper -q install -y gcc git
RUN useradd -m unpriv
USER unpriv
RUN mkdir ~/src
WORKDIR ~/src
RUN cd ~/src
RUN git clone --depth 1 https://github.com/spack/spack.git
WORKDIR ~/src/spack
RUN ls -l
