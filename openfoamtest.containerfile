FROM registry.suse.com/bci/bci-base
RUN zypper addrepo https://download.opensuse.org/repositories/network:/cluster/SLE_15_SP4/network:cluster.repo
RUN zypper addrepo https://download.opensuse.org/repositories/science/SLE_15_SP4/science.repo
RUN zypper --gpg-auto-import-keys -q install --no-recommends -y gcc{,-fortran} git openmpi4{,-devel} libopenblas_openmp0 hwloc make tar strace python3:wq
RUN ln -s /usr/lib64/libopenblas.so{.0,}
RUN useradd -m unpriv
USER unpriv
RUN mkdir -p /contents/src
WORKDIR /contents/src
RUN git clone --depth 1 https://github.com/spack/spack.git
# WORKDIR /contents/src/spack
RUN mpi-selector --set openmpi4
RUN /contents/src/spack/bin/spack -d install -v -j 16 openfoam@2012 %aocc@2.2.0 target=zen2 ^amdfftw@2.2 ^adios2~fortran ^cgal@4.13 ^openmpi@4.0.3
CMD /contents/src/spack/bin/spack load openfoam@2012 %aocc@3.2.0
