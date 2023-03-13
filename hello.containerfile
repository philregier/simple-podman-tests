FROM registry.suse.com/bci/bci-base
RUN bash -c '/usr/bin/echo Hello World!'
CMD bash -c '/usr/bin/echo Hello again!'
