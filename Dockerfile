## Alan Aytbaev - EDR Base Image
## This Dockerfile creates a container running ubuntu 16.04, ODBC Driver 17 for SQL Server (Microsoft), and GDAL 2.1.3, courtesy of the UbuntuGis Stable repository.

## Base image of ubuntu 16.04 Xenial
FROM ubuntu:16.04

## Install system utility packages
# Source: https://github.com/Microsoft/mssql-docker/tree/master/oss-drivers/pyodbc
RUN apt-get update && apt-get install -y \
    curl apt-utils apt-transport-https debconf-utils gcc build-essential g++-5\
    && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install gettext nano vim -y

## Install ODBC Driver 17 for SQL Server (Microsoft)
# Source: https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-2017
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

# install SQL Server drivers
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql unixodbc-dev

# install SQL Server tools
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y mssql-tools
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

## Install locales
# Source: https://github.com/Microsoft/mssql-docker/tree/master/oss-drivers/pyodbc
RUN apt-get update && apt-get install -y locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen
RUN pip install --upgrade pip

## Install gdal 
RUN apt-get install -y \
	software-properties-common libgd-dev gdal-bin
RUN add-apt-repository -y ppa:ubuntugis/ppa
RUN apt update
RUN apt upgrade -y
