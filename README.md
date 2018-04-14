# Docker django starter

This is a repo that helps to start a development environment for a django app with postgreSQL, based on docker

### Requirements

The main requirement to start working is [installing](https://docs.docker.com/install/linux/docker-ce/ubuntu/) Docker.
You will need also python and virtualenv

### Instalation

1. Create a new folder to allocate the stack.

  ```
  $ mkdir stack
  ```

2. Inside the folder, clone this repo.

  ```
  $ cd stack && git clone https://github.com/jhonyavella90/docker-django-starter.git
  ```

3. Create a virtualenv in the work folder, source it and install the repo requirements:

  ```
  $ virtualenv venv && source venv/bin/activate
  $ pip install -r docker-django-starter/requirements.txt
  ```

4. Go to the repo path and clone the project repos by running the following (this requires you install a ssh key from bitbucket):

  ```
  $ cd docker-django-starter
  $ make dev.clone
  ```

5. Build docker images:

  ```
  $ make dev.build
  ```

6. Start docker containers:

  ```
  $ make dev.up
  ```

7. Migrate the database:

  ```
  $ make dev.migrate
  ```

8. Start again docker containers:

  ```
  $ make dev.up
  ```

At this point you should be able to run the django app on `localhost:8000`, and the mobile app in `localhost:8100/ionic-lab`

9. To stop docker containers just run:

  ```
  $ make dev.down
  ```

### Notes

* The Mobile app docker image is based on the dockerfile from https://hub.docker.com/r/agileek/ionic-framework/~/dockerfile/
