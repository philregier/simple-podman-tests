FROM registry.suse.com/bci/bci-base
RUN zypper addrepo https://download.opensuse.org/repositories/network:/cluster/SLE_15_SP4/network:cluster.repo
RUN zypper addrepo https://download.opensuse.org/repositories/science/SLE_15_SP4/science.repo
RUN zypper --gpg-auto-import-keys -q install --no-recommends -y gcc{,-fortran} git openmpi4{,-devel} libopenblas_openmp0 hwloc make tar
RUN useradd -m unpriv
USER unpriv
RUN mkdir $HOME/src
WORKDIR $HOME/src
RUN git clone --depth 1 https://github.com/spack/spack.git
# WORKDIR $HOME/src/spack
RUN mpi-selector --set openmpi4
RUN curl -O https://netlib.org/benchmark/hpl/hpl-2.3.tar.gz
RUN tar xzf hpl-2.3.tar.gz
