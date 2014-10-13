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
no_root_location();

run_tests();

__DATA__

=== TEST 1: missing location
--- http_config eval: $::HttpConfig
--- config
    location / {
        return 400 "invalid url\n";
    }
    location /t {
        content_by_lua '
            local readurl = require "resty.readurl"
            local response, err = readurl.capture("/s", {}, false)
            if response then
                ngx.print(response)
            else
                ngx.print(err)
            end
        ';
    }
--- request
GET /t
--- response_body
invalid url
--- no_error_log
[error]



=== TEST 2: call works
--- http_config eval: $::HttpConfig
--- config
    location /s {
        return 200 "response\n";
    }
    location /t {
        content_by_lua '
            local readurl = require "resty.readurl"
            local response, err = readurl.capture("/s", {}, false)
            if response then
                ngx.print(response)
            else
                ngx.print(err)
            end
        ';
    }
--- request
GET /t
--- response_body
response
--- no_error_log
[error]



=== TEST 3: decode works
--- http_config eval: $::HttpConfig
--- config
    location /s {
        content_by_lua '
            local cjson = require "cjson"
            local response = {message="success"}
            ngx.say(cjson.encode(response))
        ';
    }
    location /t {
        content_by_lua '
            local readurl = require "resty.readurl"
            local response, err = readurl.capture("/s", {}, true)
            if response then
                ngx.say(response.message)
            else
                ngx.say(err)
            end
        ';
    }
--- request
GET /t
--- response_body
success
--- no_error_log
[error]



=== TEST 5: decode fails
--- http_config eval: $::HttpConfig
--- config
    location /s {
        content_by_lua '
            ngx.say([[{"message":"error"}}]])
        ';
    }
    location /t {
        content_by_lua '
            local readurl = require "resty.readurl"
            local response, err = readurl.capture("/s", {}, true)
            if response then
                ngx.say(response.message)
            else
                ngx.say(err)
            end
        ';
    }
--- request
GET /t
--- response_body
/s-failedExpected the end but found T_OBJ_END at character 20
--- no_error_log
[error]
