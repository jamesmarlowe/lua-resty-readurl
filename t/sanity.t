# vim:set ft= ts=4 sw=4 et:

use Test::Nginx::Socket::Lua;
use Cwd qw(cwd);

repeat_each(2);

plan tests => repeat_each() * (3 * blocks());

my $pwd = cwd();

our $HttpConfig = qq{
    lua_package_path "$pwd/lib/?.lua;;";
};

$ENV{TEST_NGINX_RESOLVER} = '8.8.8.8';

no_long_string();
#no_diff();

run_tests();

__DATA__

=== TEST 1: missing location
--- http_config eval: $::HttpConfig
--- config
    location /t {
        content_by_lua '
            local readurl = require "resty.readurl"
            local response, err = readurl.capture("/test/proxy/", {}, false)
            if response then
                ngx.say(response)
            else
                ngx.say(err)
            end
        ';
    }
--- request
GET /t
--- response_body
nope
--- no_error_log
[error]




