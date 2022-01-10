# README

This test project implements a small test web application for
generation of shortened links. When creating a new shortene link an
user must specify the full URL to redirect to. Additionally, the
lifetime of this shortened link and an abbreviation for it, if
necessary, instead of automatically generated. If when creating the
time of the new link has not been specified, then such a link will
exist forever. If the user has already generated links, then on the
page he will see a list of all links that have not been removed yet
and are still active. Any of them can be edited or deleted. It
recognizes users by the content of the "uuid" cookie, which assigned a
unique value the first time an user visits this applications.

To install this project first you need to install
[rbenv](https://github.com/rbenv/rbenv) and ruby 3.1.0 after that

```
$ rbenv install 3.1.0
```

If your rbenv installation didn't install
[ruby-build](https://github.com/rbenv/ruby-build) you can install it
from github:

```
$ git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
```

before installing of ruby 3.1.0. Now install
[bundler](https://bundler.io/) and all dependicies:

```
$ gem install bundler
$ bundle install
```

Everything is installed now and we need to setup our application as
the last step:

```
$ bin/setup
```

Ready! Now we can test it

```
$ rails t
```

and run it if all tests passed

```
$ rails s
```

and go to http://127.0.0.1:3000

Press Ctrl-C to stop it.
