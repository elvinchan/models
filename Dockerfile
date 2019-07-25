FROM tensorflow/tensorflow:1.13.1-py3

LABEL maintainer "nszr90 <elvinchan@foxmail.com>"

ADD . /ai
WORKDIR /ai/research
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    zip \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*
RUN wget -O protobuf.zip https://github.com/google/protobuf/releases/download/v3.7.0/protoc-3.7.0-linux-x86_64.zip && \
    unzip protobuf.zip -d proto3 && \
    mv proto3/bin/* /usr/local/bin && \
    mv proto3/include/* /usr/local/include && \
    rm -rf proto3 protobuf.zip && \
    protoc object_detection/protos/*.proto --python_out=.
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install matplotlib Cython Pillow
ENV PYTHONPATH "${PYTHONPATH}:/ai/research:/ai/research/slim"
RUN python ./slim/setup.py build && python ./slim/setup.py install
RUN python setup.py build && python setup.py install
RUN python object_detection/builders/model_builder_test.py