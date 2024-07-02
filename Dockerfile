FROM python:3.8-slim
# Set environment variables
ENV APP_DIR=/usr/src/snappass
ENV REDIS_URL=redis://:your_password_here@127.0.0.1:6379/0
ENV DEBUG=True
ENV NO_SSL=True

ENV APP_DIR=/usr/src/snappass

RUN groupadd -r snappass && \
    useradd -r -g snappass snappass && \
    mkdir -p $APP_DIR

WORKDIR $APP_DIR

COPY ["setup.py", "requirements.txt", "MANIFEST.in", "README.rst", "AUTHORS.rst", "$APP_DIR/"]
COPY ["./snappass", "$APP_DIR/snappass"]

RUN echo "REDIS_URL=redis://:your_password_here@127.0.0.1:6379/0" >> .env
RUN echo "DEBUG=True" >> .env
RUN echo "NO_SSL=True" >> .env

RUN python setup.py install && \
    chown -R snappass $APP_DIR && \
    chgrp -R snappass $APP_DIR
RUN pip install -r requirements.txt

USER snappass

# Default Flask port
EXPOSE 5000

CMD ["snappass"]
