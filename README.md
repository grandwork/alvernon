Requirements
============
Needs to have imagemagick installed. I used https://github.com/maddox/magick-installer to install it.

PDF generating requires wkhtmltopdf to be installed. I managed to make it work only with Passenger, so if you need to check PDF generation use Passenger as a dev server.

Only precompiled assets will be picked up by PDF, so if you make any changes to styling that should affect PDFs, run `rake assets:precompile` for changes to take effect. 

Implemented features
====================

* Redirects to login page if not authenticated
* Admin is seeded and can log in. Don't forget to run 'rake db:seed'
* Tests to make sure wrong emails and passwords won't let haxx0r in
* Admin (and only admin) can send invitation
* Admin can send invitations only to emails of @csindi.com domain


Installation
------------

Main effort to configuration of postgres. Often for a local connection postgres uses the ident of the logged-in user to authenticate with the database. You need to setup the logged in user as an owner of the alvernon database and also make it a superuser to confirm that the migrations all run successfully.

Also

sudo apt-get install postgresql-contrib to use the fuzzysearch plugin.


On snow leopard you need ARCH_FLAGS to install the pg gem successfully.

eg.
    env ARCHFLAGS="-arch x86_64" bundle install
