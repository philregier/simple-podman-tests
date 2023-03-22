FROM registry.suse.com/bci/bci-base
RUN zypper -q install -y gcc git
RUN useradd -m unpriv
USER unpriv
RUN mkdir ~/src
RUN cd ~/src
RUN git clone https://github.com/spack/spack.git
