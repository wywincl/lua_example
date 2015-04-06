local class = require "Class".class

-- define a class Type A
A = class()

-- set constructor method of class A 
function A:__ctor(s)
	self.i = 1
	self.j = 2
	print("A ctor", s)
end

-- instance of class A

a = A('a')
print(a.i, a.j)  

-- output --
-- A ctor a
-- 1  2

----------------------------------------
-- define class B inher of class A
B = class(A)

-- set constructor method of class B
function B:__ctor(s)
	self.z = 3
	print("B ctor", s)
end

-- instance of class B

b = B('b')
print(b.i, b.j, b.z)

-- output --
-- A ctor b
-- B ctor b
-- 1  2  3