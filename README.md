# __Lua 学习笔记 v1.0__

通过__《Programming in Lua》__和**《Lua程序设计》**以及网上关于Lua的相关资料，进行学习整理，总结出这一份学习笔记。为后面的初学者提供参考。
>本资料针对的是Lua5.1版本，5.2版本以后语法和库发生了显著变化，需要额外引起注意。
## <a name='TOC'>目录表</a>
  1. [简介](#profile)
  1. [语法](#grammar)
  1. [控制语句](#control_statement)
  1. [赋值语句](#rvalue)
  1. [表达式](#biaodashi)
  1. [函数](#functions)
  1. [表](#tables)
  1. [元表和元方法](#metatables_metamethods)
  1. [面向对象](#object_oriented)
  1. [模块](#modules)
  1. [参考](#references)

## <a name='profile'>简介</a>
### 背景介绍
Lua作为目前最为流行的、免费轻量级嵌入式脚本语言，在很多工业级的应用程序中被广泛应用，如Adobe's Photoshop，甚至是在一些著名的游戏程序中也被大量使用，如星际。不仅如此，由于Lua具备很多特殊的优点，如语法简单(基于过程)、高效稳定(基于字节码)、可以处理复杂的数据结构、动态类型、以及自动内存管理(基于垃圾收集)等，因此在很多嵌入式设备和智能移动设备中，为了提高程序的灵活性、扩展性和高可配置性，一般都会选择Lua作为它们的脚本引擎，以应对各种因设备不同而带来的差异。  
嵌入式路由系统OpenWRT也采用Lua编写的MVC框架luci作为自己的web框架。
***
### 主要优势
1. **高效性**  
 Lua是一种脚本语言，因此非常高效。

2. **可移植性**  
 Lua官方提供了多种平台的发布包，完全ASCII C编写，因此可以在所有平台上进行编译，如Linux，OSX, Windows等。
3. **可嵌入性**  
 在语言设计之初，Lua就被准确的定位为嵌入式脚本语言，因此Lua的设计者们为Lua提供了与其他编程语言之间的良好交互体验，这特别体现在和C/C++之间的交互上。对于其他语言，如Java和C#，也可以将Lua作为其嵌入式脚本引擎，并在代码中进行直接的交互。

4. **简单强大**   
尽管是过程化脚本语言，但由于Lua的设计者们为Lua提供了meta-mechanisms机制，这不仅使Lua具备了一些基本的面向对象特征，如对象和继承，而且仍然保持了过程化语言所具有的语法简单的特征。

5. **小巧轻便**  
Lua5.2版本编译后的库文件大小约为240K左右，因此这对于很多资源有限的平台有着极强的吸引力。

6. **免费开源**   
MIT Licence可以让Lua被免费的用于各种商业程序中。

**[[⬆]](#TOC)**
## <a name='grammar'>语法</a>
### 注释
写一个程序，总是少不了注释的。  
在Lua中，你可以使用单行注释和多行注释。  
单行注释中，连续两个减号"--"表示注释的开始，一直延续到行末为止。相当于C++语言中的"//"。  
多行注释中，由"--[["表示注释开始，并且一直延续到"]]"为止。这种注释相当于C语言中的"/*...*/"。在注释当中，"[["和"]]"是可以嵌套的（在lua5.1中，中括号中间是可以加若干个"="号的，如 [==[ ... ]==]。  
如下面这个例子exmaple1，我可以了解单行和多行注释的写法。

    example1: dispatcher.lua    
    --[[
    LuCI - Dispatcher

    Description:
    The request dispatcher and module dispatcher generators

    FileId:
    $Id$

    License:
    Copyright 2008 Steven Barth <steven@midlink.org>

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
    	http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
    
    ]]--
    --- LuCI web dispatcher.
    ...
    ...
***
### 关键字
Lua语法是非常简单的，关键字也不多，在这里需要注意：**关键字是不能做为变量的**，其他任何类型都是变量，如函数等。
关键字如下:  
    
    ----------------------------------------------------------------
    and     |   break   |   do   |   else   |   elseif   |   end
    ----------------------------------------------------------------
    false   |   for     |function|   if     |   in       |   local
    ----------------------------------------------------------------
    nil     |   not     |   or   |   while  |   repeat   |   return
    ----------------------------------------------------------------
    then    |   until   |   true |    
    ----------------------------------------------------------------
***
### 变量类型
怎么确定一个变量是什么类型的呢？大家可以用type()函数来检查。Lua支持的类型有以下几种：

    1. Nil     | 空值类型，所有没有使用过的变量都是nil类型，nil既是值，又是类型
    2. Boolean | 布尔类型，只有两个有效值：true 或false
    3. Number  | 数值类型，在Lua里，数值表示实数，相当于C语言中的double类型
    4. String  | 字符串类型，字符串是可以包含"\0"字符的（与C语言不同）
    5. Table   | 关系表类型，Lua中的核心概念，后续介绍
    6. Function| 函数类型，在Lua中函数也是一种类型，也就是说，所有的函数，本身也是一种变量。
    7. Userdata| 用户数据类型，和宿主语言进行数据交换的,这里我们不做重点介绍
    8. Thread  | 线程类型， 在Lua中是通过协程coroutine实现的


在example2中，我可以用type函数输出变量类型。
    	
    example2: type.lua
    --[[
    FileName: type.lua
    Author  : John.Wang
    Descriptions : print the type of Lua 
    ]]--
    
    print(type(nil))   --> nil
    print(type(true))  --> boolean
    print(type(1.1))   --> number 
    print(type(""))--> string
    print(type({}))--> table
    print(type(function () end))  -->function
    print(type(coroutine.create(function() end)))  -->thread

***
### 变量定义
所有的语言，都要用到变量，对于大部分动态语言来说，变量可以不用预先声明，直接使用，动态地获取自己的类型。Lua也是这样。  
在Lua中，不管在什么地方使用变量，都不需要声明，并且所有的这些变量总是全局变量，除非我们在前面加上"local"。这一点要特别注意，因为我们可能想在函数里使用局部变量，却忘了用local来说明。
**在Lua中变量是大小写敏感的**。  
>变量名可以由任意字母、数字和下划线构成，但是不能以数字开头。在Lua中还有一个特殊的规则，即以下划线(__)开头，后面紧随多个大写字母(_VERSION)，这些变量一般被Lua保留并用于特殊用途，因此我们在声明变量时需要尽量避免这样的声明方式，以免给后期的维护带来不必要的麻烦。

### 全局变量_G
在Lua脚本中，Lua将所有的全局变量保存在一个常规的table中，这个table被称为全局环境，并且将这个table保存在一个全局变量_G中，也就是说在脚本中可以用_G获取这个全局table，并且有_G._G == _G，在默认情况，Lua在全局环境_G中添加了标准库比如math、函数比如pairs等。

**[[⬆]](#TOC)**
## <a name='control_statement'>控制语句</a>
在Lua中，语句之间可以用分号"；"隔开，也可以用空白隔开。一般来说，如果多个语句写在同一行的话，建议总是用分号隔开。  
Lua 有好几种程序控制语句，如：

    --------------------------------------------------------------------------------------------
    控制语句    | 格式                                         | 示例
    --------------------------------------------------------------------------------------------
    If         | if 条件 then ... elseif then ... else ...end | if true then print("true")      
    --------------------------------------------------------------------------------------------
    While      | while 条件 do ... end                        | while true do print("true") end
    --------------------------------------------------------------------------------------------
    Repeat     | repeat ... until 条件                        | repeat print("true") until false  
    --------------------------------------------------------------------------------------------
    For        | for 变量=初值，终点值，步长值 do ... end       | for i=1, 10, 2 do print(i) end 
    --------------------------------------------------------------------------------------------
    For  | for 变量1,变量2,...变量n in 表或者枚举函数 do... end | for k,v ipairs(_G) print(k,v) end
    --------------------------------------------------------------------------------------------
>注意一下，for的循环变量总是只作用于for的局部变量；当省略步进值时，for循环会使用1作为步进值。

使用break可以用来中止一个循环。

**[[⬆]](#TOC)**
## <a name='rvalue'>赋值语句</a>
赋值语句在Lua被强化了。它可以同时给多个变量赋值。  
例如：
  
    a,b,c,d=1,2,3,4
    甚至是：
    a,b=b,a  -- 多么方便的交换变量功能啊。
    在默认情况下，变量总是认为是全局的。假如需要定义局部变量，则在第一次赋值的时候，需要用local说明。比如：
    local a,b,c = 1,2,3  -- a,b,c都是局部变量

这里面需要注意的是，不能这样的赋值 如，`local a,b,c = 1`. 这种形式在Lua中被解析成`local a,b,c = 1, nil, nil`。
并不是C语言中的对所有变量都赋值为1。

**[[⬆]](#TOC)**
## <a name='biaodashi'>表达式</a>

### 数值运算
和C语言一样，支持 +, -, *, /。但Lua还多了一个"^"。这表示指数乘方运算。比如2^3 结果为8, 2^4结果为16。  
连接两个字符串，可以用".."运处符。如："This a " .. "string." -- 等于 "this a string"
***
### 比较运算
    比较符号  |    <     |    >    |    <=     |    >=     |    ==     |    ~=    |
    符号意义  | 小于      |   大于  | 小于等于   |   大于等于 |     等于   |   不等于  |

所有这些操作符总是返回true或false。  
对于Table，Function和Userdata类型的数据，只有 == 和 ~=可以用。相等表示两个变量引用的是同一个数据。比如：

    a={1,2}
    b=a
    print(a==b, a~=b)  --输出 true, false
    a={1,2}
    b={1,2}
    print(a==b, a~=b)  --输出 false, true
***
### 逻辑运算
and, or, not  
其中，and 和 or 与C语言区别特别大。  
在这里，请先记住，在Lua中，只有false和nil才计算为false，其它任何数据都计算为true，0也是true！  
and 和 or的运算结果不是true和false，而是和它的两个操作数相关。  
a and b：如果a为false，则返回a；否则返回b  
a or b：如果 a 为true，则返回a；否则返回b  

举几个例子：
    
    print(4 and 5) --输出 5
    print(nil and 13) --输出 nil
    print(false and 13) --输出 false
    print(4 or 5) --输出 4
    print(false or 5) --输出 5

在Lua中这是很有用的特性，也是比较令人混洧的特性。  
我们可以模拟C语言中的语句：`x = a? b : c`，在Lua中，可以写成：`x = a and b or c`。  
最有用的语句是： `x = x or v`，它相当于：`if not x then x = v end` 。  

但是上面`x = a and b or c`并不是总是对的，在特定情况下才可以使用，当b为true时。

运算符优先级，从低到高顺序如下：

    or
    and
    < > <= >= ~= ==
    .. (string concat)
    + -
    * / %
    not #(取长度运算符,lua 5.1) -(一元运算)
    ^
>和C语言一样，括号可以改变优先级。

**[[⬆]](#TOC)**
## <a name='functions'>函数</a>
### 基础函数
函数，在Lua中，函数的定义也很简单。典型的定义如下：  

    function add(x, y)    -- add是函数名，x,y 是参数名
        return x + y      -- return用来返回函数的运行结果
    end 

>请注意，return语言一定要写在end之前。假如我们非要在中间放上一句return，那么就应该要写成：
`do return end`。

>需要说明的是，Lua中实参和形参的数量可以不一致，一旦出现这种情况，Lua的处理规则等同于多重赋值，即实参多于形参，多出的部分被忽略，如果相反，没有被初始化的形参的缺省值为nil。

还记得前面说过，函数也是变量类型吗？上面的函数定义，其实相当于：

    add = function (x,y) return x+y end

当重新给add赋值时，它就不再表示这个函数了。我们甚至可以赋给add任意数据，包括nil （这样，赋值为nil，将会把该变量清除）。在Lua中Function很像C语言的函数指针呢？

和C语言一样，Lua的函数可以接受可变参数个数，它同样是用"..."来定义的，比如：
    
    function sum(x,y, ...)

如果想取得...所代表的参数，可以在函数中访问arg局部变量（表类型）得到 (lua5.1: 取消arg，并直接用"..."来代表可变参数了，本质还是arg)。

Lua中，函数可以返回多个值，这点和python相似，但是python实际上是返回一个元组而已，不是真正意义上的多值。

    function s()
        return 1,2,3,4
    end

    a,b,c,d = s() -- 此时，a = 1, b = 2, c = 3, d = 4

**命名参数**  
在python中，函数可以带有命名参数。如`rename(oldname=newname, oldage=newage)`
这样，在传入参数的时候，可以不用考虑参数的顺序。  
在Lua中，我们不可以直接这样使用，但是我们可以通过表来传递命名参数，这里Lua函数有个特性  
对于参数为字符串常量或者表时，可以不用写()，直接 · 

***
### 高阶函数
Lua中的函数是带有词法定界（lexical scoping）的第一类值（first-class values）。  
第一类值指：在Lua中函数和其他值（数值、字符串）一样，函数可以被存放在变
量中，也可以存放在表中，可以作为函数的参数，还可以作为函数的返回值。

**词法定界**  
当一个函数内部嵌套另一个函数定义时，内部的函数体可以访问外部的函数的局部
变量，这种特征我们称作词法定界。  
  
**闭包**  
函数闭包: 一个函数和它所使用的所有upvalue构成了一个函数闭包。

看下面这个例子：

    -- 生成函数, 返回一个显示n次c字符的closure
    function rep_char(c, n)
      -- 特别注意这个 local 否则fun就是global, 后面的递归就错了.
      local function fun()
	    	if n > 0 then
		    	 print (c);
		    	 -- 递归显示
		    	 n = n-1;
		    	 fun();
    		end
      end
      return fun;
    end
    
    
    -- 生成两个closure
    f1 = rep_char("A", 3);
    f2 = rep_char("B", 5);
    
    
    -- 调用
    f1();
    f2();


**尾调函数**  
在Lua中支持这样一种函数调用的优化，即“尾调用消除”。我们可以将这种函数调用方式视为goto语句，如：
>在Lua5.3版本中，提供了goto关键字，从语法层面支持的goto语句，但是还是有一定限制，具体可参看5.3版本的用户手册。

    function f(x) return g(x) end

由于g(x)函数是f(x)函数的最后一条语句，在函数g返回之后，f()函数将没有任何指令需要被执行，因此在函数g()返回时，可以直接返回到f()函数的调用点。由此可见，Lua解释器一旦发现g()函数是f()函数的尾调用，那么在调用g()时将不会产生因函数调用而引起的栈开销。这里需要强调的是，尾调用函数一定是其调用函数的最后一条语句，否则Lua不会进行优化。然而事实上，我们在很多看似是尾调用的场景中，实际上并不是真正的尾调用，如：

    function f(x) g(x) end            --没有return语句的明确提示
    function f(x) return g(x) + 1  --在g()函数返回之后仍需执行一次加一的指令。
    function f(x) return x or g(x) --如果g()函数返回多个值，该操作会强制要求g()函数只返回一个值。
    function f(x) return (g(x))     --原因同上。

在Lua中，只有"`return <func>(<args>)`"形式才是标准的尾调用，至于参数中(args)是否包含表达式，由于表达式的执行是在函数调用之前完成的，因此不会影响该函数成为尾调用函数。
   
## <a name='tables'>表</a>

关系表类型，这是一个很强大的类型。我们可以把这个类型看作是一个数组。只是C语言的数组，只能用正整数来作索引；在Lua中，你可以用任意类型来作数组的索引，除了nil。同样，在C语言中，数组的内容只允许一种类型；在Lua中，你也可以用任意类型的值来作数组的内容，除了nil。  
Table的定义很简单，它的主要特征是用"{"和"}"来括起一系列数据元素的。比如：

    T1 = {}  -- 定义一个空表  
    T1[1]=10  -- 然后我们就可以象C语言一样来使用它了。
    T1["John"]={Age=27, Gender="Male"}

这一句相当于：

    T1["John"]={}  -- 必须先定义成一个表，还记得未定义的变量是nil类型吗
    T1["John"]["Age"]=27
    T1["John"]["Gender"]="Male"

当表的索引是字符串的时候，我们可以简写成：

    T1.John={}
    T1.John.Age=27
    T1.John.Gender="Male"或
    T1.John{Age=27, Gender="Male"}

这是一个很强的特性。

在定义表的时候，我们可以把所有的数据内容一起写在"{"和"}"之间，这样子是非常方便，而且很好看。比如，前面的T1的定义，我们可以这么写：
    
     T1 =
    　{
    　　　　　　10,  -- 相当于 [1] = 10
    　　　　　　[100] = 40,
    　　　　　　John=  -- 如果你原意，你还可以写成：["John"] =
    　　　　　　{
    　　　　　　　　Age=27,   -- 如果你原意，你还可以写成：["Age"] =27
    　　　　　　　　Gender=Male   -- 如果你原意，你还可以写成：["Gender"] =Male
    　　　　　　},
    　　　　　　20  -- 相当于 [2] = 20
    　}

我们在写的时候，需要注意三点：  
第一，所有元素之间，总是用逗号"，"隔开；  
第二，所有索引值都需要用"["和"]"括起来；如果是字符串，还可以去掉引号和中括号；  
第三，如果不写索引，则索引就会被认为是数字，并按顺序自动从1往后编；  

表类型的构造是如此的方便，以致于常常被人用来代替配置文件。是的，不用怀疑，它比ini文件要漂亮，并且强大的多。

**[[⬆]](#TOC)**
## <a name='metatables_metamethods'>元表和元方法</a>
### 元表
#### 什么是元表
 Lua中Metatable这个概念, 国内将他翻译为元表. 元表为重定义Lua中任意一个对象(值)的默认行为提供了一种公开入口. 如同许多OO语言的操作符重载或方法重载. Metatable能够为我们带来非常灵活的编程方式. 

具体的说, Lua中每种类型的值都有都有他的默认操作方式, 如, 数字可以做加减乘除等操作, 字符串可以做连接操作, 函数可以做调用操作, 表可以做表项的取值赋值操作. 他们都遵循这些操作的默认逻辑执行, 而这些操作可以通过Metatable来改变. 如, 你可以定义2个表如何相加等. 

看一个最简单的例子, 重定义了2个表的加法操作. 这个例子中将c的 `__add`域改写后将a的Metatable设置为c, 当执行到加法的操作时, Lua首先会检查a是否有Metatable并且Metatable中是否存在__add域, 如果有则调用, 否则将检查b的条件(和a相同), 如果都没有则调用默认加法运算, 而table没有定义默认加法运算, 则会报错.

    --定义2个表
    a = {5, 6}
    b = {7, 8}
    --用c来做Metatable
    c = {}
    --重定义加法操作
    c.__add = function(op1, op2)
       for _, item in ipairs(op2) do
      table.insert(op1, item)
       end
       return op1
    end
    --将a的Metatable设置为c
    setmetatable(a, c)
    --d现在的样子是{5,6,7,8}
    d = a + b

有了个感性的认识后, 我们看看Metatable的具体特性.  
Metatable并不神秘, 他只是一个普通的table, 在table这个数据结构当中, Lua定义了许多重定义这些操作的入口. 他们均以双下划线开头为table的域, 如上面例子的`__add`. 当你为一个值设置了Metatable, 并在Metatable中设置了重写了相应的操作域, 在这个值执行这个操作的时候就会触发重写的自定义操作. 当然每个操作都有每个操作的方法格式签名, 如`__add`会将加号两边的两个操作数做为参数传入并且要求一个返回值. 有人把这样的行为比作事件, 当xx行为触发会激活事件自定义操作.

Metatable定义的操作有：  

    add, sub, mul, div, mod, pow, unm, concat, len, eq, lt, le,
	 tostring, gc, index, newindex, call...

在Lua中任何一个值都有Metatable, 不同的值可以有不同的Metatable也可以共享同样的Metatable, 但在Lua本身提供的功能中, 不允许你改变除了table类型值外的任何其他类型值的Metatable, 除非使用C扩展或其他库.
> setmetatable和getmetatable是唯一一组操作table类型的Metatable的方法.


Lua的语法非常灵活, 使用他的metatable及metamethod可以模拟出很多语言的特性. 

**[[⬆]](#TOC)**
## <a name='object_oriented'>面向对象</a>
Lua中，面向对向是用元表这种机制来实现的。元表是个很“道家”的机制，很深遂，很强大，里面有一些基本概念比较难理解透彻。不过，只有完全理解了元表，才能对Lua的面向对象使用自如，才能在写Lua代码的高级语法时游刃有余。

首先，一般来说，一个表和它的元表是不同的个体（不属于同一个表），在创建新的table时，不会自动创建元表。
但是，任何表都可以有元表（这种能力是存在的）。

    e.g.
    t = {}
    print(getmetatable(t))   --> nil
    t1 = {}
    setmetatable(t, t1)
    assert(getmetatable(t) == t1)

setmetatable( 表1， 表2) 将表2挂接为表1的元表，并且返回经过挂接后的表1。

元表中的`__metatable`字段，用于隐藏和保护元表。当一个表与一个赋值了__metatable的元表进行挂接时，用getmetatable操作这个表，就会返回`__metatable`这个字段的值，而不是元表！用setmetatable操作这个表（即给这个表赋予新的元表），那么就会引发一个错误。

元表中的`__index`元方法，是一个非常强力的元方法，它为回溯查询（读取）提供了支持。而面向对象的实现基于回溯查找。
当访问一个table中不存在的字段时，得到的结果为nil。这是对的，但并非完全正确。实际上，如果这个表有元表的话，这种访问会促使Lua去查找元表中的`__index`元方法。如果没有这个元方法，那么访问结果就为nil。否则，就由这个元方法来提供最终的结果。

`__index`可以被赋值为一个函数，也可以是一个表。是函数的时候，就调用这个函数，传入参数（参数是什么后面再说），并返回若干值。是表的时候，就以相同的方式来重新访问这个表。（是表的时候，`__index`就相当于元字段了，概念上还是分清楚比较好，虽然在Lua里面一切都是值）

对于没有元表的表，访问一个不存在的字段，就直接返回一个nil了。

`__newindex`是对应`__index`的方法，它的功能是“更新（写）”，两者是互补的。这里不细讲`__newindex`，但是过程很相似，灵活使用两个元方法会产生很多强大的效果。

从继承特性角度来讲，初步的效果使用`__index`就可以实现了。

### 面向对象的实现
Lua应该说，是一种原型语言。原型是一种常规的对象，当其他对象（类的实例）遇到一个未知的操作时，原型会去查找这个原型。在这种语言中要表示一个类，只需创建一个专用作其他对象的原型。实际上，类和原型都是一种组织对象间共享行为的方式。

下面是一中类的创建和对象构造的例子。

    --账户基类：Account
    Account = {balance = 100.00} --有一个blance属性
    
    ---模拟Account实例化和继承思想所需的方法new()
    function Account:new(o)
	    o = o or { }
	    setmetatable(o,self)
	    self.__index = self
	    return o
    end
    
    --Account类的方法deposit（存款）
    function Account:deposit( v )
   		self.balance = self.balance + v
    end
    
    --Account类的方法deposit（取款）
    function Account:withdraw( v )
    	if v > self.balance then error "no enph money!"
    	end
    	self.balance = self.balance - v
    end
    ----------------------------------------------------------------------------------------
    
    --派生子类
    spacialAccount = Account:new{limit = 1000.00,rate = 0.100}
    
    --子类的新方法
    function spacialAccount:setrate( v )
    	self.rate = v;
    end
    
    --实例化子类，得到对象s
    s = spacialAccount:new()
    
    --对象调用方法
    s:setrate(0.300)
    
    print(s.balance)
    print(s.limit)
    print(s.rate)

子类继承父类，和实例化类产生新对象都用new（）方法模拟实现，实现形式一样，但概念是不一样的。

不过在实际工程中，我们并不用上面的方式来构造类和对象。一般我们推荐下面这种方式。

	-- class.lua
    module(..., package.seeall)
    function class(super)
    	local mt = {
    	__call = function (_c, ...)
    		local function ct(_c, _o, ...)
    			if _c.__super then ct(_c.__super, _o, ...) end
    			if _c.__ctor then _c.__ctor(_o, ...) end
    			return _o
    		end
    		local _o = ct(_c, {}, ...)
    		return setmetatable(_o, _c)
    	end
    	}
    	mt.__index = super or mt
    	return setmetatable({__super=super}, mt)
    end


测试用例：

	--test.lua
    local class = require "class".class
    
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
    -- define class B inherited class A
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


**[[⬆]](#TOC)**
## <a name='modules'>模块</a>
从Lua 5.1开始，我们可以使用require和module函数来获取和创建Lua中的模块。从使用者的角度来看，一个模块就是一个程序库，可以通过require来加载，之后便得到一个类型为table的全局变量。此时的table就像名字空间一样，可以访问其中的函数和常量，如:

	require "mod"
	mod.foo()
	local m2 = require "mod2"
	local f = mod2.foo
	f()

### require 函数
require函数的调用形式为require "模块名"。该调用会返回一个由模块函数组成的table，并且还会定义一个包含该table的全局变量。在使用Lua中的标准库时可以不用显示的调用require，因为Lua已经预先加载了他们。   

 require函数在搜素加载模块时，有一套自定义的模式，如：
    
    ?;?.lua;c:/windows/?;/usr/local/lua/?/?.lua
    在上面的模式中，只有问号(?)和分号(;)是模式字符，分别表示require函数的参数(模块名)和模式间的分隔符。如：调用require "sql"，将会打开以下的文件：
    sql
    sql.lua
    c:/windows/sql
    /usr/local/lua/sql/sql.lua

Lua将`require`搜索的模式字符串放在变量`package.path`中。当Lua启动后，便以环境变量`LUA_PATH`的值来初始化这个变量。如果没有找到该环境变量，则使用一个编译时定义的默认路径来初始化。如果`require`无法找到与模块名相符的Lua文件，就会找C程序库。C程序库的搜索模式存放在变量`package.cpath`中。而这个变量则是通过环境变量`LUA_CPATH`来初始化的。

### 编写模块的基本方法
见如下代码和关键性注释：

	--将模块名设置为require的参数，这样今后重命名模块时，只需重命名文件名即可。
	local modname = ...
	local M = {}
	_G[modname] = M
	
	M.i = {r = 0, i = 1}  --定义一个模块内的常量。
	function M.new(r,i) return {r = r, i = i} end
	function M.add(c1,c2) 
	    return M.new(c1.r + c2.r,c1.i + c2.i)
	end
	
	function M.sub(c1,c2)
	    return M.new(c1.r - c2.r,c1.i - c2.i)
	end
	--返回和模块对应的table。
	return M

### 使用环境

仔细阅读上例中的代码，我们可以发现一些细节上问题。比如模块内函数之间的调用仍然要保留模块名的限定符，如果是私有变量还需要加local关键字，同时不能加模块名限定符。如果需要将私有改为公有，或者反之，都需要一定的修改。那又该如何规避这些问题呢？我们可以通过Lua的函数“全局环境”来有效的解决这些问题。见如下修改的代码和关键性注释：

	--模块设置和初始化。这一点和上例一致。
	local modname = ...
	local M = {}
	_G[modname] = M
	
	--声明这个模块将会用到的全局函数，因为在setfenv之后将无法再访问他们，
	--因此需要在设置之前先用本地变量获取。
	local sqrt = mat.sqrt
	local io = io
	
	--在这句话之后就不再需要外部访问了。
	setfenv(1,M)
	
	--后面的函数和常量定义都无需模块限定符了。
	i = {r = 0, i = 1}
	function new(r,i) return {r = r, i = i} end
	function add(c1,c2) 
	    return new(c1.r + c2.r,c1.i + c2.i)
	end
	 
	function sub(c1,c2)
	    return new(c1.r - c2.r,c1.i - c2.i)
	end
	--返回和模块对应的table。
	return M

### module函数

在Lua 5.1中，我们可以用module(...)函数来代替以下代码，如：

	local modname = ...
	local M = {}
	_G[modname] = M
	package.loaded[modname] = M
	    --[[
	    和普通Lua程序块一样声明外部函数。
	    --]]
	setfenv(1,M)

由于在默认情况下，module不提供外部访问，必须在调用它之前，为需要访问的外部函数或模块声明适当的局部变量。然后Lua提供了一种更为方便的实现方式，即在调用module函数时，多传入一个package.seeall的参数，如：

    module(...,package.seeall)

> 注意，Lua5.2版本以后，不支持module函数了，官方推荐自己构造一套require/module机制。


**[[⬆]](#TOC)**
## <a name='references'>参考</a>
1. 《Programming in Lua》  
1. 《Lua中文教程》  
1. 《The Implementation of Lua 5.0》
1. 《Lua参考手册》
1. 《Lua快速入门》
