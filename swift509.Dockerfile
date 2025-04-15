FROM swift:5.9

WORKDIR /app

COPY Package.swift ./
COPY Package.resolved ./

RUN swift package resolve --skip-update --force-resolved-versions

COPY ./Plugins ./Plugins
COPY ./Sources ./Sources
COPY ./Tests ./Tests

