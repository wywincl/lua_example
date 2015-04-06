module(..., package.seeall)

function class(super)
	local mt = {
		__call = function (_c, ...)
			local function create(_c, _o, ...)
				if _c.__super then create(_c.__super, _o, ...) end
				if _c.__ctor then _c.__ctor(_o, ...) end
				return _o
			end
			local _o = create(_c, {}, ...)
			return setmetatable(_o, _c)
		end
	}
	mt.__index = super or mt
	return setmetatable({__super=super}, mt)
end