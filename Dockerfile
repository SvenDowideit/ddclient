FROM alpine
MAINTAINER Sven Dowideit <SvenDowideit@home.org.au>

# Build using `docker build -t ddclient .`
# Then run with `docker run --rm -it ddclient --help`
# docker run --rm -it -v $(pwd)/ddclient.config:/etc/ddclient/ddclient.conf ddclient -foreground -ip 10.10.10.2

RUN apk add --update perl && rm -rf /var/cache/apk/*
RUN apk add --update make && rm -rf /var/cache/apk/*
RUN apk add --update perl-io-socket-ssl && rm -rf /var/cache/apk/*
RUN apk add --update ca-certificates && rm -rf /var/cache/apk/*

# TODO: does not want to be run as root
#RUN apk add --update apkbuild-cpan && rm -rf /var/cache/apk/*
#RUN apk add --update abuild && rm -rf /var/cache/apk/*
#RUN abuild-keygen -a -i
#RUN apkbuild-cpan create Data::Validate::IP

#use cpanm
# TODO: argh, doing it this way needs make!
RUN PERL_MM_USE_DEFAULT=1 cpan \
	&& cpan App::cpanminus
# NOPE. ssl isn't there by default
#RUN  cd $TMP_DIR && wget http://cpanmin.us | perl - App::cpanminus
#            if [ \! -f /usr/local/bin/cpanm ]; then
#                    echo "Downloading from cpanmin.us failed, downloading from xrl.us"
#                    wget http://xrl.us/cpanm &&
#            chmod +x cpanm &&
#            mv cpanm /usr/local/bin/cpanm`
#ADD https://raw.githubusercontent.com/miyagawa/cpanminus/master/cpanm /usr/local/bin/cpanm
#RUN chmod 755 /usr/local/bin/cpanm

# NOTE: the --no-wget option won't be needed when cpanminus 2.0 is released
# https://github.com/miyagawa/cpanminus/issues/471#issuecomment-126170184
RUN cpanm install --no-wget Data::Validate::IP
RUN cpanm install --no-wget JSON::Any

COPY ddclient /usr/sbin/
RUN mkdir /etc/ddclient \
	&& mkdir /var/cache/ddclient
COPY sample-etc_ddclient.conf /etc/ddclient/ddclient.conf

ENTRYPOINT ["/usr/sbin/ddclient"]
