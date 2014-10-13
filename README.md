Name
====

lua-resty-readurl - Lua library for capturing urls, decoding, and logging results

Table of Contents
=================

* [Name](#name)
* [Status](#status)
* [Description](#description)
* [Synopsis](#synopsis)
* [Methods](#methods)
    * [capture](#capture)
* [Limitations](#limitations)
* [Installation](#installation)
* [TODO](#todo)
* [Community](#community)
    * [English Mailing List](#english-mailing-list)
    * [Chinese Mailing List](#chinese-mailing-list)
* [Testing](#testing)
* [Bugs and Patches](#bugs-and-patches)
* [Author](#author)
* [Copyright and License](#copyright-and-license)
* [See Also](#see-also)

Status
======

This library is still under early development but production ready.

Description
===========

This Lua library for capturing urls, decoding and logging:

Synopsis
========

```lua
    lua_package_path "/path/to/lua-resty-readurl/lib/?.lua;;";

    server {
        location /test {
            content_by_lua '
                local readurl = require "resty.readurl"
                local response, err = readurl.capture("/postgres/proxy/", {sql=sql}, true, {failure_log_level=ngx.CRIT, success_log_level=ngx.INFO, counter_dict=nginx_logging_dict})
                ngx.say(response)
            ';
        }
        
        location /postgres/proxy/ {
            return 200 "success";
        }
    }
```

[Back to TOC](#table-of-contents)

Methods
=======

All of the commands return either something that evaluates to true on success, or `nil` and an error message on failure.

capture
-------
`syntax: response, err = readurl.capture(url, url_arguments, decode, log_table)`
`syntax: response, err = readurl.capture("/postgres/proxy/", {sql=sql}, true, {failure_log_level=ngx.CRIT, success_log_level=ngx.INFO, counter_dict=nginx_logging_dict})`

In case of success, returns the response of the location. In case of errors, returns `nil` with a string describing the error.

[Back to TOC](#table-of-contents)

Limitations
===========

[Back to TOC](#table-of-contents)

Installation
============
You can install it with luarocks `luarocks install lua-resty-readurl`

Otherwise you need to configure the lua_package_path directive to add the path of your lua-resty-readurl source tree to ngx_lua's LUA_PATH search path, as in

```nginx
    # nginx.conf
    http {
        lua_package_path "/path/to/lua-resty-readurl/lib/?.lua;;";
        ...
    }
```

This package also requires the lua-cjson package to be installed

Ensure that the system account running your Nginx ''worker'' proceses have
enough permission to read the `.lua` file.

TODO
====

[Back to TOC](#table-of-contents)

Community
=========

[Back to TOC](#table-of-contents)

English Mailing List
--------------------

The [openresty-en](https://groups.google.com/group/openresty-en) mailing list is for English speakers.

[Back to TOC](#table-of-contents)

Chinese Mailing List
--------------------

The [openresty](https://groups.google.com/group/openresty) mailing list is for Chinese speakers.

[Back to TOC](#table-of-contents)

Testing
=======

Running the tests in t/ is simple once you know whats happening. They use perl's prove and agentzh's test-nginx.

```
sudo apt-get install perl build-essential curl
sudo cpan Test::Nginx
mkdir -p ~/work 
cd ~/work 
git clone https://github.com/agentzh/test-nginx.git 
cd /path/to/lua-resty-readurl/
make test #assumes openresty installed to /usr/bin/openresty/
```

[Back to TOC](#table-of-contents)

Bugs and Patches
================

Please report bugs or submit patches by

1. creating a ticket on the [GitHub Issue Tracker](http://github.com/jamesmarlowe/lua-resty-readurl/issues),

[Back to TOC](#table-of-contents)

Author
======

James Marlowe "jamesmarlowe" <jameskmarlowe@gmail.com>, Lumate LLC.

[Back to TOC](#table-of-contents)

Copyright and License
=====================

This module is licensed under the BSD license.

Copyright (C) 2012-2014, by James Marlowe (jamesmarlowe) <jameskmarlowe@gmail.com>, Lumate LLC.

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

[Back to TOC](#table-of-contents)

See Also
========
* the ngx_lua module: http://wiki.nginx.org/HttpLuaModule

[Back to TOC](#table-of-contents)
