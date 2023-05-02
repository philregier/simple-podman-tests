FROM registry.suse.com/bci/bci-base
RUN zypper addrepo https://download.opensuse.org/repositories/network:/cluster/SLE_15_SP4/network:cluster.repo
RUN zypper addrepo https://download.opensuse.org/repositories/science/SLE_15_SP4/science.repo
RUN zypper --gpg-auto-import-keys -q install --no-recommends -y gcc{,-fortran} git jq vi \
      openmpi4{,-devel} libopenblas_openmp0 hwloc make tar strace python3 xz libxml2 m4 libtool
RUN ln -s /usr/lib64/libopenblas.so{.0,}
RUN mkdir -p /contents/src
RUN useradd -m unpriv
RUN chown -R unpriv /contents
USER unpriv
RUN python3 -m venv /contents/python
RUN source /contents/python/bin/activate && pip install --upgrade pip && pip install yq
WORKDIR /contents/src
RUN git clone --depth 1 https://github.com/spack/spack.git
# WORKDIR /contents/src/spack
RUN mpi-selector --set openmpi4
RUN /contents/src/spack/bin/spack external find
# The following is an ugly hack and should not be used.
RUN source /contents/python/bin/activate && VERSION="$(rpm -q libxml2-2 --qf %{VERSION})" && yq -yi '.packages.libxml2.externals = [{"prefix":"/usr","spec":"libxml2@$VERSION"}]' /home/unpriv/.spack/packages.yaml
RUN /contents/src/spack/bin/spack install -v aocc@3.2.0 +license-agreed
RUN cd $(/contents/src/spack/bin/spack location --install-dir aocc@3.2.0); /contents/src/spack/bin/spack compiler add $PWD
RUN source /var/mpi-selector/data/openmpi4.sh; /contents/src/spack/bin/spack -d install -v -j 16 openfoam@2012 %aocc@3.2.0 target=zen2 ^amdfftw@2.2 ^adios2~fortran ^cgal@4.13 ^openmpi@4.0.3
CMD /contents/src/spack/bin/spack load openfoam@2012 %aocc@3.2.0
