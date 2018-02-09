FROM rocker/shiny:latest

WORKDIR /srv/shiny-server

RUN sed -i 's%deb.debian.org%mirror.bytemark.co.uk%' /etc/apt/sources.list

# Cleanup shiny-server dir
RUN rm -rf ./*

# Make sure the directory for individual app logs exists
RUN mkdir -p /var/log/shiny-server

#Install packages (ideally this would be done with packrat...)
RUN R -e "install.packages(c('shiny', 'ggvis', 'dplyr', 'RSQLite'))"

RUN R -e "install.packages( 'dbplyr')"

# Add shiny app code
COPY ./app .

# Shiny runs as 'shiny' user, adjust app directory permissions
RUN chown -R shiny:shiny .

# APT Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/

# Run shiny-server on port 8080
RUN sed -i 's/3838/8080/g' /etc/shiny-server/shiny-server.conf
EXPOSE 8080
