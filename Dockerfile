# Basic container
FROM debian:bookworm-slim

ENV domain=localhost

# Install the important things
RUN apt update && \
    apt-get install apache2 libapache2-mod-wsgi-py3 -y && \
    apt-get install python3 python3-pip python3-venv -y && \
    apt update

# Generate the flask WSGI file
RUN echo "import sys\nsys.path.insert(0, '/var/www/html/')\nfrom main import app as application" > /var/www/html/flaskapp.wsgi
RUN echo "from flask import Flask\napp = Flask(__name__)\n@app.route('/')\ndef hello_world():\n\treturn 'Hello, World!'" > /var/www/html/main.py

# Generate the new good file
RUN echo "<VirtualHost *:80>\n\tServerName 127.0.0.1\n\tServerAdmin webmaster@$domain\n\tDocumentRoot /var/www/html\n\tWSGIDaemonProcess flaskapp python-path=/var/www/html/venv/lib/python3.11\n\tWSGIScriptAlias / /var/www/html/flaskapp.wsgi\n\tWSGIApplicationGroup %{GLOBAL}\n\t<Directory /var/www/html>\n\t\tWSGIProcessGroup flaskapp\n\t\tWSGIApplicationGroup %{GLOBAL}\n\t\tOrder deny,allow\n\t\tAllowOverride All\n\t\tAllow from all\n\t</Directory>\n\tErrorLog ${APACHE_LOG_DIR}/error.log\n\tCustomLog ${APACHE_LOG_DIR}/access.log combined\n</VirtualHost>" > /etc/apache2/sites-enabled/000-default.conf

RUN rm /usr/lib/python3.11/EXTERNALLY-MANAGED && \
    pip install flask && \
    rm /var/www/html/index.html

RUN echo "" > /var/www/html/.htaccess

EXPOSE 80

WORKDIR /var/www/html

CMD apachectl -D FOREGROUND