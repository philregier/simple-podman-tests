FROM registry.suse.com/bci/bci-base
RUN zypper addrepo https://download.opensuse.org/repositories/network:/cluster/SLE_15_SP4/network:cluster.repo
RUN zypper --gpg-auto-import-keys -q install --no-recommends -y gcc git
RUN useradd -m unpriv
USER unpriv
RUN mkdir ~/src
WORKDIR ~/src
RUN git clone --depth 1 https://github.com/spack/spack.git
RUN ls -l spack
RUN pwd
WORKDIR ~/src/spack
RUN ls -l
RUN pwd
