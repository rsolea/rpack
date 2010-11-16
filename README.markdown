Rpack 
=====
An easy way to pack some Rails functionalities
---------------------------------------------------------------------

### Install

gem install rpack

### Packing

Suppose you have a Rails app with some features you'd love to keep to replicate to other ones, when building them. Let's take a look on a project with these models, and let's suppose they came from a scaffold with all the package it provides, like controllers, migrations and tests:

    [taq@smith/tmp/rpack]$ ls app/models/
    drwxr-xr-x 2 taq taq 4,0K 2010-11-15 22:55 .
    drwxr-xr-x 7 taq taq 4,0K 2010-11-15 22:54 ..
    -rw-r--r-- 1 taq taq   36 2010-11-15 22:55 city.rb
    -rw-r--r-- 1 taq taq   39 2010-11-15 22:54 country.rb
    -rw-r--r-- 1 taq taq   37 2010-11-15 22:54 state.rb
    -rw-r--r-- 1 taq taq   36 2010-11-15 22:55 user.rb

We often use some stuff like countries, states and cities on a lot of apps, right? So, I want to keep all those functionalities on a file to use again when creating another app that needs that. So, I can use **rpack** to create a package (just a zip file, no secrets there) and store it till I need it again, just typing:

    rpack country state city
    [taq@smith/tmp/rpack]$ rpack country state city
    Using basedir /tmp/rpack
    Packing to citycountrystate.zip ...
    processing countries ...
    processing states ...
    processing cities ...

First thing to notice is the automatic package name, with keywords sorted, so now there is a *citycountrystate.zip* file with this content:

[taq@smith/tmp/rpack]$ unzip -l citycountrystate.zip 
    Archive:  citycountrystate.zip
    Length      Date    Time    Name
    ---------  ---------- -----   ----
    1888  2010-11-15 23:54   app/controllers/cities_controller.rb
     2023  2010-11-15 23:54   app/controllers/countries_controller.rb
     1916  2010-11-15 23:54   app/controllers/states_controller.rb
       36  2010-11-15 23:54   app/models/city.rb
       39  2010-11-15 23:54   app/models/country.rb
       37  2010-11-15 23:54   app/models/state.rb
      592  2010-11-15 23:54   app/views/cities/_form.html.erb
      111  2010-11-15 23:54   app/views/cities/edit.html.erb
      496  2010-11-15 23:54   app/views/cities/index.html.erb
       76  2010-11-15 23:54   app/views/cities/new.html.erb
      212  2010-11-15 23:54   app/views/cities/show.html.erb
      507  2010-11-15 23:54   app/views/countries/_form.html.erb
      120  2010-11-15 23:54   app/views/countries/edit.html.erb
      473  2010-11-15 23:54   app/views/countries/index.html.erb
       82  2010-11-15 23:54   app/views/countries/new.html.erb
      174  2010-11-15 23:54   app/views/countries/show.html.erb
      601  2010-11-15 23:54   app/views/states/_form.html.erb
      113  2010-11-15 23:54   app/views/states/edit.html.erb
      509  2010-11-15 23:54   app/views/states/index.html.erb
       77  2010-11-15 23:54   app/views/states/new.html.erb
      220  2010-11-15 23:54   app/views/states/show.html.erb
       24  2010-11-15 23:54   app/helpers/cities_helper.rb
       27  2010-11-15 23:54   app/helpers/countries_helper.rb
       24  2010-11-15 23:54   app/helpers/states_helper.rb
      205  2010-11-15 23:54   db/migrate/20101116005434_create_countries.rb
      224  2010-11-15 23:54   db/migrate/20101116005449_create_states.rb
      222  2010-11-15 23:54   db/migrate/20101116005503_create_cities.rb
      151  2010-11-15 23:54   test/unit/city_test.rb
      154  2010-11-15 23:54   test/unit/country_test.rb
       73  2010-11-15 23:54   test/unit/helpers/states_helper_test.rb
      152  2010-11-15 23:54   test/unit/state_test.rb
     1031  2010-11-15 23:54   test/functional/cities_controller_test.rb
     1100  2010-11-15 23:54   test/functional/countries_controller_test.rb
     1050  2010-11-15 23:54   test/functional/states_controller_test.rb
      147  2010-11-15 23:54   test/fixtures/cities.yml
      119  2010-11-15 23:54   test/fixtures/countries.yml
      151  2010-11-15 23:54   test/fixtures/states.yml
       63  2010-11-15 23:54   config/routes.rb
    ---------                     -------
    15219                     38 files

When packing, just one thing to take a special attention: the **config/routes.rb** file. Let's take a look on it:

    [taq@smith/tmp]$ mkdir contents
    [taq@smith/tmp]$ cd contents/
    [taq@smith/tmp/contents]$ unzip ../rpack/citycountrystate.zip > /dev/null
    [taq@smith/tmp/contents]$ cat config/routes.rb 
      resources :countries
      resources :states
      resources :cities

The *routes.rb* file contents were extracted to get info about the keywords we asked, but right now **just basic route info are supported*. This is the only file when content is extracted to be merged later, all the other files have some same content as the original ones.

If you don't like the default package name convention, you can create your own:

    [taq@smith/tmp/rpack]$ rpack country state city -p localities.zip
    Using basedir /tmp/rpack
    Packing to /tmp/rpack/localities.zip ...
    processing countries ...
    processing states ...
    processing cities ...

If you just want to pack models, views and controllers, you can:

    [taq@smith/tmp/rpack]$ rpack country state city -p localitiesmvc.zip -mvc
    Using basedir /tmp/rpack
    Packing to /tmp/rpack/localitiesmvc.zip ...
    processing countries ...
    processing states ...
    processing cities ...
    [taq@smith/tmp/rpack]$ unzip -l localitiesmvc.zip 
    Archive:  localitiesmvc.zip
    Length      Date    Time    Name
    ---------  ---------- -----   ----
       36  2010-11-15 23:27   app/models/city.rb
       39  2010-11-15 23:27   app/models/country.rb
       37  2010-11-15 23:27   app/models/state.rb
      592  2010-11-15 23:27   app/views/cities/_form.html.erb
      111  2010-11-15 23:27   app/views/cities/edit.html.erb
      496  2010-11-15 23:27   app/views/cities/index.html.erb
       76  2010-11-15 23:27   app/views/cities/new.html.erb
      212  2010-11-15 23:27   app/views/cities/show.html.erb
      507  2010-11-15 23:27   app/views/countries/_form.html.erb
      120  2010-11-15 23:27   app/views/countries/edit.html.erb
      473  2010-11-15 23:27   app/views/countries/index.html.erb
       82  2010-11-15 23:27   app/views/countries/new.html.erb
      174  2010-11-15 23:27   app/views/countries/show.html.erb
      601  2010-11-15 23:27   app/views/states/_form.html.erb
      113  2010-11-15 23:27   app/views/states/edit.html.erb
      509  2010-11-15 23:27   app/views/states/index.html.erb
       77  2010-11-15 23:27   app/views/states/new.html.erb
      220  2010-11-15 23:27   app/views/states/show.html.erb
     1888  2010-11-15 23:27   app/controllers/cities_controller.rb
     2023  2010-11-15 23:27   app/controllers/countries_controller.rb
     1916  2010-11-15 23:27   app/controllers/states_controller.rb
    ---------                     -------
    10302                     21 files

### Command line options

There are some command line options:

    [taq@smith/tmp/rpack]$ rpack
    No name given Usage: rpack <name> [options]
    -a, --all
    -c, --controller
    -m, --model
    -v, --view
    -h, --helper
    -l, --mailer
    -g, --migration
    -u, --unit
    -f, --functional
    -i, --integration
    -o, --performance
    -x, --fixture
    -r, --route
    -k, --unpack
    -t, --inflections FILE
    -d, --dir DIR
    -p, --package FILE

Not all are working right now.

### Unpacking

So, now you have your package and want to use on another project. We can go to the new project dir and use:

    [taq@smith/tmp/newproj]$ runpack ../rpack/citycountrystate.zip 
    Unpacking /tmp/rpack/citycountrystate.zip to /tmp/newproj ...
    Extracting:
    app/controllers/cities_controller.rb to
    /tmp/newproj/app/controllers/cities_controller.rb

Some points to notice:

#### Migrations

Taking a look at the migrations dir:

    [taq@smith/tmp/newproj]$ ls db/migrate/
    total 20K
    drwxr-xr-x 2 taq taq 4,0K 2010-11-16 00:11 .
    drwxr-xr-x 3 taq taq 4,0K 2010-11-16 00:11 ..
    -rw-r--r-- 1 taq taq  205 2010-11-16 00:11 20101116021115_create_countries.rb
    -rw-r--r-- 1 taq taq  224 2010-11-16 00:11 20101116021116_create_states.rb
    -rw-r--r-- 1 taq taq  222 2010-11-16 00:11 20101116021117_create_cities.rb

The original migrations names were:

    -rw-r--r-- 1 taq taq  205 2010-11-15 22:54 20101116005434_create_countries.rb
    -rw-r--r-- 1 taq taq  224 2010-11-15 22:54 20101116005449_create_states.rb
    -rw-r--r-- 1 taq taq  222 2010-11-15 22:55 20101116005503_create_cities.rb

The migrations names were updated to the UTC time they were unpacked, as you can see on the output:

    Extracting:
    db/migrate/20101116005434_create_countries.rb to
    /tmp/newproj/db/migrate/20101116021259_create_countries.rb

    Extracting:
    db/migrate/20101116005449_create_states.rb to
    /tmp/newproj/db/migrate/20101116021300_create_states.rb

    Extracting:
    db/migrate/20101116005503_create_cities.rb to
    /tmp/newproj/db/migrate/20101116021301_create_cities.rb

This will (hopefully) avoid conflicts and put the unpacked migrations on the end.

#### Routes

As said, basic routes functionality is supported, and we can see on the output:

    Merging:
    config/routes.rb to
    /tmp/newproj/config/routes.rb

Let's take a look on the routes file:

    [taq@smith/tmp/newproj master]$ cat config/routes.rb 
    Newproj::Application.routes.draw do
        resources :users
        ...
        resources :countries
        resources :states
        resources :cities
    end

And there are the keywords routes merged.

### Duplicated content

If some file with the same name as one who **rpack** is trying to extract already exist, its name will be appended with a _rpack_ on the end.

### Output file and dir

We can specify an output file (as seen above) on another path and unpack it on another dir:

    [taq@smith/tmp/rpack]$ rpack country state city -p /tmp/locals.zip
    Using basedir /tmp/rpack
    Packing to /tmp/locals.zip ...
    processing countries ...
    processing states ...
    processing cities ...
    [taq@smith/tmp/rpack]$ ls /tmp/locals.zip 
    -rw-r--r-- 1 taq taq 12K 2010-11-16 00:33 /tmp/locals.zip
    [taq@smith/tmp/rpack]$ runpack /tmp/locals.zip -d /tmp/newproj
    Unpacking /tmp/locals.zip to /tmp/newproj ...
    Extracting:
    app/controllers/cities_controller.rb to
    /tmp/newproj/app/controllers/cities_controller.rb

