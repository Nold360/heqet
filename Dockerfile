FROM squidfunk/mkdocs-material
RUN adduser -s/bin/bash -u1000 -D nold
USER 1000
