# This file was generated by the Julia OpenAPI Code Generator
# Do not modify this file directly. Modify the OpenAPI specification instead.


function delete_order_read(handler)
    function delete_order_read_handler(req::HTTP.Request)
        openapi_params = Dict{String,Any}()
        path_params = HTTP.getparams(req)
        openapi_params["orderId"] = OpenAPI.Servers.to_param(String, path_params, "orderId", required=true, )
        req.context[:openapi_params] = openapi_params

        return handler(req)
    end
end

function delete_order_validate(handler)
    function delete_order_validate_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        op = "delete_order"
        
        n = "orderId"
        v = get(openapi_params, n, nothing)
        isnothing(v) && throw(OpenAPI.ValidationException(;reason="missing parameter $n", operation_or_model=op))
        if !isnothing(v)
            if isa(v, OpenAPI.APIModel)
                OpenAPI.validate_properties(v)
                if !OpenAPI.check_required(v)
                    throw(OpenAPI.ValidationException(;reason="$n is missing required properties", operation_or_model=op))
                end
            end
        end

        return handler(req)
    end
end

function delete_order_invoke(impl; post_invoke=nothing)
    function delete_order_invoke_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        ret = impl.delete_order(req::HTTP.Request, openapi_params["orderId"];)
        resp = OpenAPI.Servers.server_response(ret)
        return (post_invoke === nothing) ? resp : post_invoke(req, resp)
    end
end

function get_inventory_read(handler)
    function get_inventory_read_handler(req::HTTP.Request)
        openapi_params = Dict{String,Any}()
        req.context[:openapi_params] = openapi_params

        return handler(req)
    end
end

function get_inventory_validate(handler)
    function get_inventory_validate_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        op = "get_inventory"

        return handler(req)
    end
end

function get_inventory_invoke(impl; post_invoke=nothing)
    function get_inventory_invoke_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        ret = impl.get_inventory(req::HTTP.Request;)
        resp = OpenAPI.Servers.server_response(ret)
        return (post_invoke === nothing) ? resp : post_invoke(req, resp)
    end
end

function get_order_by_id_read(handler)
    function get_order_by_id_read_handler(req::HTTP.Request)
        openapi_params = Dict{String,Any}()
        path_params = HTTP.getparams(req)
        openapi_params["orderId"] = OpenAPI.Servers.to_param(Int64, path_params, "orderId", required=true, )
        req.context[:openapi_params] = openapi_params

        return handler(req)
    end
end

function get_order_by_id_validate(handler)
    function get_order_by_id_validate_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        op = "get_order_by_id"
        
        n = "orderId"
        v = get(openapi_params, n, nothing)
        isnothing(v) && throw(OpenAPI.ValidationException(;reason="missing parameter $n", operation_or_model=op))
        if !isnothing(v)
            OpenAPI.validate_param(n, op, :maximum, v, 5, false)
            OpenAPI.validate_param(n, op, :minimum, v, 1, false)
        end

        return handler(req)
    end
end

function get_order_by_id_invoke(impl; post_invoke=nothing)
    function get_order_by_id_invoke_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        ret = impl.get_order_by_id(req::HTTP.Request, openapi_params["orderId"];)
        resp = OpenAPI.Servers.server_response(ret)
        return (post_invoke === nothing) ? resp : post_invoke(req, resp)
    end
end

function place_order_read(handler)
    function place_order_read_handler(req::HTTP.Request)
        openapi_params = Dict{String,Any}()
        openapi_params["Order"] = OpenAPI.Servers.to_param_type(Order, String(req.body))
        req.context[:openapi_params] = openapi_params

        return handler(req)
    end
end

function place_order_validate(handler)
    function place_order_validate_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        op = "place_order"
        
        n = "Order"
        v = get(openapi_params, n, nothing)
        isnothing(v) && throw(OpenAPI.ValidationException(;reason="missing parameter $n", operation_or_model=op))
        if !isnothing(v)
            if isa(v, OpenAPI.APIModel)
                OpenAPI.validate_properties(v)
                if !OpenAPI.check_required(v)
                    throw(OpenAPI.ValidationException(;reason="$n is missing required properties", operation_or_model=op))
                end
            end
        end

        return handler(req)
    end
end

function place_order_invoke(impl; post_invoke=nothing)
    function place_order_invoke_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        ret = impl.place_order(req::HTTP.Request, openapi_params["Order"];)
        resp = OpenAPI.Servers.server_response(ret)
        return (post_invoke === nothing) ? resp : post_invoke(req, resp)
    end
end


function registerStoreApi(router::HTTP.Router, impl; path_prefix::String="", optional_middlewares...)
    HTTP.register!(router, "DELETE", path_prefix * "/store/order/{orderId}", OpenAPI.Servers.middleware(impl, delete_order_read, delete_order_validate, delete_order_invoke; optional_middlewares...))
    HTTP.register!(router, "GET", path_prefix * "/store/inventory", OpenAPI.Servers.middleware(impl, get_inventory_read, get_inventory_validate, get_inventory_invoke; optional_middlewares...))
    HTTP.register!(router, "GET", path_prefix * "/store/order/{orderId}", OpenAPI.Servers.middleware(impl, get_order_by_id_read, get_order_by_id_validate, get_order_by_id_invoke; optional_middlewares...))
    HTTP.register!(router, "POST", path_prefix * "/store/order", OpenAPI.Servers.middleware(impl, place_order_read, place_order_validate, place_order_invoke; optional_middlewares...))
    return router
end
