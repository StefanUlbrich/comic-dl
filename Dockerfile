# this buld the base image to run comic_dl
FROM python:3.6.5-slim-stretch AS base
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -yq upgrade
# update system & install basisc stuff
#        and dependencies for phantomjs
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq \
    build-essential \
    chrpath \
    libssl-dev \
    libxft-dev \
    libfreetype6 \
    libfreetype6-dev \
    libfontconfig1 \
    libfontconfig1-dev
    #wget nodejs-legacy

# We're not using PhantomJS anymore. So, this step should be removed for now.
# install phantomjs and symlink to /usr/local/bin/
#RUN wget -q https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 && \
#    tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2 -C /usr/local/share/ && \
#    ln -s /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/

# This install comic-dl and symlink to comic_dl command
ENV PYTHONPATH "${PYTHONPATH}:/opt/comic-dl/comic_dl/"
COPY / /opt/comic-dl
RUN python -m pip install --upgrade pip && \
    python -m pip install -r /opt/comic-dl/requirements.txt && \
    chmod +x /opt/comic-dl/comic_dl/__main__.py  && \
    cp /opt/comic-dl/comic_dl/__main__.py /usr/local/bin/comic_dl
