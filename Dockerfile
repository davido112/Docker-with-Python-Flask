# Basic container
FROM python:3.11.6

ARG admin_email
ARG domain

# Install the important things
RUN apt update && \
    apt-get install apache2 libapache2-mod-wsgi-py3 -y && \
    apt update

# Generate the flask WSGI file
RUN echo "import sys\nsys.path.insert(0, '/var/www/html/')\nfrom main import app as application" > /var/www/html/flaskapp.wsgi
RUN echo "from flask import Flask\napp = Flask(__name__)\n@app.route('/')\ndef hello_world():\n\treturn 'Hello, World!'" > /var/www/html/main.py

# Generate the new good file
RUN echo "<VirtualHost *:80>\n\tServerName $domain\n\tServerAdmin $admin_email\n\tDocumentRoot /var/www/html\n\tWSGIDaemonProcess flaskapp python-path=/var/www/html/venv/lib/python3.11\n\tWSGIScriptAlias / /var/www/html/flaskapp.wsgi\n\tWSGIApplicationGroup %{GLOBAL}\n\t<Directory /var/www/html>\n\t\tWSGIProcessGroup flaskapp\n\t\tWSGIApplicationGroup %{GLOBAL}\n\t\tOrder deny,allow\n\t\tAllowOverride All\n\t\tAllow from all\n\t</Directory>\n\tErrorLog ${APACHE_LOG_DIR}/error.log\n\tCustomLog ${APACHE_LOG_DIR}/access.log combined\n</VirtualHost>" > /etc/apache2/sites-enabled/000-default.conf

# Remove the EXTERNALLY-MANAGED for can use the PIP in the container
RUN rm /usr/lib/python3.11/EXTERNALLY-MANAGED && \
    pip install flask && \
    rm /var/www/html/index.html

# Install nano
RUN apt-get install nano -y

# Generate .htaccess
RUN echo "" > /var/www/html/.htaccess

# OPTIONAL!!!
# CertBot install
# RUN apt install certbot python3-certbot-apache -y && \
#     certbot certonly --agree-tos --email $admin_email --domain $domain

EXPOSE 80

WORKDIR /var/www/html

CMD apachectl -D FOREGROUND