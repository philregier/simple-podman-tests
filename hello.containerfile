FROM registry.suse.com/bci/bci-base
RUN bash -c '/usr/bin/echo Hello World >&2'
CMD bash -c '/usr/bin/echo Hello again >&2'
