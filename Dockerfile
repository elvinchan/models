FROM tensorflow/tensorflow:1.13.1-py3

LABEL maintainer "nszr90 <elvinchan@foxmail.com>"

ADD . /ai
WORKDIR /ai/research
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    zip \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*
RUN wget -O protobuf.zip https://github.com/google/protobuf/releases/download/v3.6.0/protoc-3.6.0-linux-x86_64.zip \
    && unzip -o protobuf.zip \
    && ./bin/protoc object_detection/protos/*.proto --python_out=.
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN export PYTHONPATH=$PYTHONPATH:pwd:pwd/slim
RUN python ./slim/setup.py build && python ./slim/setup.py install
RUN python setup.py build && python setup.py install
RUN python object_detection/builders/model_builder_test.py