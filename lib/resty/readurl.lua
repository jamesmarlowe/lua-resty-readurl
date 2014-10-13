-- Copyright (C) James Marlowe (jamesmarlowe), Lumate LLC.

local cjson  = require "cjson"

local ok, new_tab = pcall(require, "table.new")
if not ok then
    new_tab = function (narr, nrec) return {} end
end

local _M = new_tab(0, 155)
_M._VERSION = '0.1'

function _M.capture(url, url_arguments, decode, log_table)
    local ok, response = pcall(ngx.location.capture, url, url_arguments)
    
    if not log_table then log_table = {} end
    if not log_table['success_log_level'] then
        log_table['success_log_level'] = ngx.NOTICE
    end
    if not log_table['failure_log_level'] then
        log_table['failure_log_level'] = ngx.ERR
    end
    
    local message = url.."-total"
    ngx.log(log_table['success_log_level'], message)
    if log_table['counter_dict'] then
        local val = log_table['counter_dict']:incr(message, 1)
        if not val then log_table['counter_dict']:add(message, 1) end
    end
    
    if ok and response
        if not decode then
            local message = url.."-success"
            ngx.log(log_table['success_log_level'], message..response)
            if log_table['counter_dict'] then
                local val = log_table['counter_dict']:incr(message, 1)
                if not val then log_table['counter_dict']:add(message, 1) end
            end
            return response.body
        else
            local ok, result = pcall(cjson.decode, response.body)
            if ok and result
                local message = url.."-success"
                ngx.log(log_table['success_log_level'], message..result)
                if log_table['counter_dict'] then
                    local val = log_table['counter_dict']:incr(message, 1)
                    if not val then log_table['counter_dict']:add(message, 1) end
                end
                return result
            else
                local message = url.."-failed"
                ngx.log(log_table['failure_log_level'], message..result)
                if log_table['counter_dict'] then
                    local val = log_table['counter_dict']:incr(message, 1)
                    if not val then log_table['counter_dict']:add(message, 1) end
                end
                return nil, message..result
            end
        end
    else
        local message = url.."-failed"
        ngx.log(log_table['failure_log_level'], message..response)
        if log_table['counter_dict'] then
            local val = log_table['counter_dict']:incr(message, 1)
            if not val then log_table['counter_dict']:add(message, 1) end
        end
        return nil, message..response
    end
end

return _M
