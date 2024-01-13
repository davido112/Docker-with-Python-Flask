# Python Flask
Created: https://github.com/davido112/Docker-with-Python-Flask/tree/main
## What is Python Flask?
Python Flask is a lightweight and versatile web framework designed to make it easy to build web applications. Created by Armin Ronacher, Flask follows the WSGI (Web Server Gateway Interface) standard, making it compatible with various web servers. Flask is known for its simplicity and flexibility, allowing developers to quickly create web applications with minimal boilerplate code.
## How to use this image?
### Like YML file
    version: "3"
    services:
      flask:
        image: flask:3.11.6-debian
	    args:
          admin_email: <EMAIL-ADDRESS>
          domain: <DOMAIN-NAME>
        restart: unless-stopped
        ports:
          - "8080:80"
        volumes:
          - ./path/to/my/folder:/var/www/html
