# NAME
Catmandu::Store::Datahub - Store/retrieve items from the [Datahub](https://github.com/thedatahub/Datahub)

# SYNOPSIS
A module that allows to interface with the Datahub as a Catmandu::Store.

Supports retrieving, adding, deleting and updating of data.

# MODULES
* [Catmandu::Store::Datahub]()
* [Catmandu::Store::Datahub::Bag]()
* [Catmandu::Store::Datahub::Generator]()
* [Catmandu::Store::Datahub::OAuth]()
* [Catmandu::Bag::IdGenerator::Datahub]()

# DESCRIPTION
Configure the [Datahub](https://github.com/thedatahub/Datahub) as a [store](http://librecat.org/Catmandu/#stores) for [Catmandu](http://librecat.org/).

With Catmandu, it is possible to convert (almost) any data to [LIDO](http://lido-schema.org/), which is suitable for importing in the Datahub. This module allows you to integrate the importing in your Catmandu workflow by setting up a Catmandu-compatible interface between the Datahub and Catmandu.

Note that you must convert your data to LIDO in order to use this module. All other formats will result in an error.

## Configuration
To configure the store, the location of the Datahub is required. As OAuth2 is used, a client id and secret are also required, as well as a username and a password.

* `url`: base url of the Datahub (e.g. _http://www.datahub.be_).
* `client_id`: OAuth2 client ID.
* `client_secret`: OAuth2 client secret.
* `username`: Datahub username.
* `password`: Datahub password.

## Usage
See [the Catmandu documentation](http://librecat.org/Catmandu/#stores) for more information on how to use Stores.

# SEE ALSO
* [Catmandu-LIDO](https://github.com/LibreCat/Catmandu-LIDO)

# AUTHOR
Pieter De Praetere, `<pieter@packed.be>`

# CONTRIBUTORS

# LICENSE AND COPYRIGHT
This program is free software; you can redistribute it and/or modify it under the terms of version 3 of the GNU General Public License as published by the Free Software Foundation.