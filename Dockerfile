FROM python:3.6-alpine

ENV GRAPHVIZ_DOT /usr/bin/dot

# Install
RUN mkdir -p /opt/plantuml && \
    apk --no-cache add openjdk8-jre graphviz make ttf-dejavu wget unzip && \
	wget http://sourceforge.net/projects/plantuml/files/plantuml.jar/download -O /opt/plantuml/plantuml.jar && \
	wget http://jaist.dl.sourceforge.jp/vlgothic/44715/VLGothic-20091202.zip -O /tmp/font.zip && \
	unzip /tmp/font.zip -d /usr/share/fonts/ && \
	rm /tmp/font.zip && \
	fc-cache -fv && \
	pip install sphinx sphinxcontrib-plantuml && \
	apk del wget unzip

RUN mkdir /work
WORKDIR /work
CMD ["make", "html"]

