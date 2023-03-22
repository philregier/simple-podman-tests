FROM registry.suse.com/bci/bci-base
RUN zypper -q install -y gcc git
RUN useradd -m unpriv
USER unpriv
RUN mkdir ~/src
WORKDIR ~/src
RUN cd ~/src
RUN git clone --depth 0 https://github.com/spack/spack.git
WORKDIR ~/src/spack
RUN ls -l
