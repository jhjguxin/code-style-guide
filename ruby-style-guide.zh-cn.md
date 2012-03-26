# 序

> 风格可以用来区分从好到卓越。<br />
> -- Bozhidar Batsov

有一件事情总是困扰着，作为Ruby程序员的我 - python 开发者都有一个很棒的编程风格参考
([PEP-8](http://www.python.org/dev/peps/pep-0008/))，然而我们从没有一个官方的（公认）的guide，Ruby代码风格文档和最佳实践。而且我信赖这些风格（的一些约定）。我也相信下面的一些好东西，像我们这样的Ruby开发者，也应该有能力写出这样的梦寐以求的文档。

这份指南诞生于我们公司内部的Ruby编程准则，基于Ruby社区的大多数成员会对我正在做的有兴趣这样的发点，我决定做这样的工作，而且世界上很少需要另一个公司内部的（编程）准则。但是这个世界将会一定有益于社区驱动的以及社区认可的，Ruby习惯和风格实践。

自从这个guide（发表）以来，我收到了很多来自优秀的Ruby社区的世界范围内的成员的回馈。感谢所有的建议和支持！集我们大家之力，我们可以创作出对每一个Ruby开发人员有益的资源。

补充，如果你正在使用rails你可能会希望查阅[Ruby on Rails 3 Style Guide](https://github.com/bbatsov/rails-style-guide).

# Ruby 风格指南

这个Ruby风格指南推荐（一些）最佳实践使得现实世界中的Ruby程序员可以写出能够被其他真是世界的Ruby程序员维护的代码。一个风格指南反映了真实世界的使用习惯，同时一个风格指南紧紧把握一个观点那就是人们拒绝接受任何有可能无法使用指南的风险，无论它多好。

这个指南被分为几个具有相关的rules的几节。我尝试给rules添加合理的解释（如果它被省略我假设它相当的明显了）。

我并没有列举所有的rules - 它们大多数基于我作为一个专业的软件工程师的广泛生涯，回馈和来自Ruby社区成员的建议以及各种备受推崇的Ruby编程资源，例如["Programming Ruby 1.9"](http://pragprog.com/book/ruby3/programming-ruby-1-9)
和 ["The Ruby Programming Language"](http://www.amazon.com/Ruby-Programming-Language-David-Flanagan/dp/0596516177).

这个指南仍然在工作进程中 - 一些rules缺乏例子，一些rules没有合适的例子来使得它们足够明了。

你可以使用[Transmuter](https://github.com/TechnoGate/transmuter).来生成指南的PDF或者HTML的copy。

## 源代码布局

> 附近的每个人都深信每一个风格除了他们自己的都是
> 丑陋的并且难以阅读的。脱离"but their own"那么他们
> 完全正确... <br />
> -- Jerry Coffin (on indentation缩进)

* 使用 `UTF-8` 作为源文件编码。
* 每个缩进级别使用两个 **spaces** 

    ```Ruby
    # good
    def some_method
      do_something
    end

    # bad - four spaces
    def some_method
        do_something
    end
    ```

* 使用Unix-风格行结束。(*BSD/Solaris/Linux/OSX 用户被涵盖为默认，Windows 用户必须特别小心.)
> \n是换行，英文是LineFeed，ASCII码是0xA。
> \r是回车，英文是Carriage Return ,ASCII码是0xD。
> windows下enter是 \n\r,unix下是\n,mac下是\r
    * 如果你正在使用Git你可能会想要添加下面的配置设置来保护你的项目（避免）Windows蔓延过来的行结束符:
        ```$ git config --global core.autecrlf true```

* 使用空格：在操作符旁；逗号，冒号和分号后；在 `{`旁和在 `}`之前，大多数空格可能对Ruby解释（代码）无关，但是它的恰当使用是让代码变得易读的关键。

    ```Ruby
    sum = 1 + 2
    a, b = 1, 2
    1 > 2 ? true : false; puts 'Hi'
    [1, 2, 3].each { |e| puts e }
    ```

    唯一的例外是当使用指数操作时：

    ```Ruby
    # bad
    e = M * c ** 2

    # good
    e = M * c**2
    ```

* 没有空格 `(`, `[`之后或者 `]`, `)`之前。

    ```Ruby
    some(arg).other
    [1, 2, 3].length
    ```

* `when`和`case` 缩进深度一致。我知道很多人会不同意这点，但是它是"The Ruby Programming Language" 和 "Programming Ruby"中公认的风格。

    ```Ruby
    case
    when song.name == 'Misty'
      puts 'Not again!'
    when song.duraton > 120
      puts 'Too long!'
    when Time.now > 21
      puts "It's too late"
    else
      song.play
    end

    kind = case year
           when 1850..1889 then 'Blues'
           when 1890..1909 then 'Ragtime'
           when 1910..1929 then 'New Orleans Jazz'
           when 1930..1939 then 'Swing'
           when 1940..1950 then 'Bebop'
           else 'Jazz'
           end
    ```

* 使用空行在 `def`s 并且一个方法根据逻辑段来隔开。

    ```Ruby
    def some_method
      data = initialize(options)

      data.manipulate!

      data.result
    end

    def some_methods
      result
    end
    ```
* 如果一个方法的调用参数分割为多行将它们于**方法名**对齐。

    ```Ruby
    # starting point (line is too long)
    def send_mail(source)
      Mailer.deliver(to: 'bob@example.com', from: 'us@example.com', subject: 'Important message', body: source.text)
    end
    # bad (normal indent)
    def send_mail(source)
      Mailer.deliver(
        to: 'bob@example.com',
        from: 'us@example.com',
        subject: 'Important message',
        body: source.text)
    end

    # bad (double indent)
    def send_mail(source)
      Mailer.deliver(
          to: 'bob@example.com',
          from: 'us@example.com',
          subject: 'Important message',
          body: source.text)
    end
    # good
    def send_mail(source)
      Mailer.deliver(to: 'bob@example.com',
                     from: 'us@example.com',
                     subject: 'Important message',
                     body: source.text)
    end
    ```

* 在 API 文档中使用 RDoc和它的公约。不要在注释代码块和`def`之间加入空行。
* 保持每一行少于80字符。
* 避免尾随空格。

## 语法

* 使用括号将`def`的参数括起来。当方法不接收任何参数的时候忽略括号。

    ```Ruby
    def some_method
      # body omitted
    end

    def some_method_with_arguments(arg1, arg2)
      # body omitted
    end
    ```

* 从来不要使用 `for`， 除非你知道使用它的准确原因。大多数时候迭代器都可以用来替代for。`for` is implemented in terms of `each`#`for`是`each`的组实现 (因此你正间接添加了一级)，但是有一个小道道 - `for`并不包含一个新的scope(不像`each`)并且在它的块中定义的变量在外面也是可以访问的。

    ```Ruby
    arr = [1, 2, 3]

    # bad
    for elem in arr do 
      puts elem
    end

    puts elem # => 3

    # good
    arr.each { |elem| puts elem }
    ```

* 在多行的`if/unless`中坚决不要使用`then`.

    ```Ruby
    # bad
    if some_condition then
      # body omitten
    end

    # good
    if some_condition
      # body omitted
    end
    ```

* 喜欢三元操作运算（`?:`）超过`if/then/else/end`结果。
  它更加普遍而且明显的更加简洁。

    ```Ruby
    # bad
    result = if some_condition then something else something_else end

    # good
    result = some_condition ? something : something_else
    ```

* 使用一个表达式在三元操作运算的每一个分支下面只使用一个表达式。也就是说三元操作符不要被嵌套。在这样的情形中宁可使用`if/else`。

    ```Ruby
    # bad
    some_condition ? (nested_condition ? nested_something : nested_something_else) : something_else

    # good
    if some_condition
      nested_condition ? nested_something : nested_something_else
    else
      something_else
    end
    ```

* 使用三元操作运算代替`if x: ...`。

* 在 one-line cases 的时候使用`when x then ...`。替代的语法`when x: xxx`已经在Ruby 1.9中移除。

* 不要使用`when x; ...`。查看上面的规则。

* 布尔表达式使用`&&/||`, `and/of`用于控制流程。（经验Rule:如果你必须使用额外的括号（表达逻辑），那么你正在使用错误的的操作符。）

    ```Ruby
    # boolean expression
    if some_condition && some_other_condition
      do_something
    end

    # control flow
    document.save? or document.save!
    ```

* 避免多行`?:`(三元操作运算)，使用`if/unless`替代。

* 在单行语句的时候喜爱使用`if/unless`修饰符。另一个好的选择就是使`and/of`来做流程控制。

    ```Ruby
    # bad
    if some_condition
      do_something
    end

    # good
    do_something if some_condition

    # another good option
    some_condition and do_something
    ```

* 在否定条件下喜欢`unless`超过`if`(或者控制流程 `or`)。

    ```Ruby
    # bad
    do_something if !some_condition

    # good
    do_something unless some_condition

    # another good option
    some_condition or do_something
    ```

* 不要使用`else`搭配`unless`。将其的语义重写为肯定形式。

    ```Ruby
    # bad
    unless sucess?
      puts 'failure'
    else
      puts 'sucess'
    end

    # good
    if sucess?
      puts 'sucess'
    else
      puts 'failure'
    end
    ```

* 不要在`if/unless/while`将条件旁括起来，除非这个条件包含一个参数(参见下面 "使用`=`返回值")。

    ```Ruby
    # bad
    if (x>10)
      # body omitted
    end

    # good
    if x > 10
      # body omitted
    end

    # ok
    if (x = self.next_value)
      # body omitted
    end
    ```

* DSL(e.g. Rake, Rails, RSpec)里的方法，Ruby“关键字”方法(e.g. `attr_reader`, `puts`)以及属性访问方法，所带参数忽略括号。使用括号将在其他方法调用的参数括起来。

    ```Ruby
    class Person
      attr_reader :name, :age

      # omitted
    end

    temperance = Person.new('Temperance', 30)
    temperance.name

    puts temperance.age

    x = Math.sin(y)
    array.delete(e)
    ```

* 在单行代码块的时候宁愿使用`{...}`而不是`do...end`。避免在多行代码块使用`{...}`(多行链式通常变得非常丑陋)。通常使用`do...end`来做`流程控制`和`方法定义`(例如 在Rakefiles和某些DSLs中)。避免在链式调用中使用`do...end`。

    ```Ruby
    names = ["Bozhidar", "Steve", "Sarah"]

    #good
    names.each { |name| puts name }

    #bad
    names.each do |name|
      puts name
    end

    # good
    names.select { |name| name.start_with?("S") }.map { |name| name.upcase }

    # bad
    names.select do |name|
      name.start_with?("S")
    end.map { |name| name.upcase }
    ```

    有人会争论多行链式看起来和使用`{...}`一样工作，但是他们问问自己 - 这样的代码真的有可读性码并且为什么代码块中的内容不能被提取到美丽的methods。

* 避免在不需要的地方使用`return`

    ```Ruby
    # bad
    def some_method(some_arr)
      return some_arr.size
    end

    # good
    def some_method(some_arr)
      some_arr.size
    end
    ```

* 当分配默认值给方法参数的时候，在`=`附近使用空格。

    ```Ruby
    # bad
    def some_method(arg1=:default, arg2=nil, arg3=[])
      # do something...
    end

    # good
    def some_method(arg1 = :default, arg2 = nil, arg3 = [])
      # do something...
    end
    ```

* 避免在不需要的时候使用行连接符(`\\`)。实际上应该避免行连接符。

    ```Ruby
    # bad
    result = 1 - \
             2

    # good (but still ugly as hell)仍然像地狱一样丑陋
    result = 1 \
             - 2
    ```
* 使用`=`返回一个表达式的值是很好的，但是需要用括号把赋值运算式括起来。

    ```Ruby
    # good - show intented use of assignment
    if (v = array.grep(/foo/)) ...

    # bad
    if v = array.grep(/foo/) ...

    # also good - show intended use of assignment and has correct precedence.
    if (v = self.next_value) == "hello" ...
    ```

* 使用`||=`轻松的初始化变量。

    ```Ruby
    # set name to Vozhidar, only if it's nil or false
    name ||= 'Bozhidar'
    ````

* 不要使用`||=`来初始化布尔变量。（思考一些如果当前值为`false`的时候会发生什么。）

    ```Ruby
    # bad - would set enabled to true even if it was false
    enable ||= true

    # good
    enabled = true if enabled.nil?
    ```

* 避免使用Perl的指定变量风格（比如，`$0-9`，`$`，等等。）。它们相当神秘，不鼓励在单行代码之外使用它们。

* 从来不要在方法名和（参数）开括号之间使用空格。

    ```Ruby
    # bad
    f (3+2) + 1

    # good
    f(3 + 2) +1
    ```

* 如果方法的第一个参数以开括号开始，通常使用括号把它们全部括起来。例如`f((3 + 2) + 1)`。

* 通常使用-w 选项运行Ruby解释器，在你忘记上面所诉规则，ruby将会提示你。

* 当你的hash字典是symbols的时候，使用Ruby 1.9的字面量语法。

    ```Ruby
    # bad
    hash = { :one => 1, :two => 2 }

    #good
    hash = { one: 1, two: 2 }
    ```

* 使用新的 lambda 语法。

    ```Ruby
    # bad
    lambda = lambda { |a, b| a + b }
    lambda.call(1, 2)

    # good
    lambda = ->(a, b) { a + b }
    lambda.(1, 2)
    ```

* 对不使用的块变量使用`_`。

    ```Ruby
    # bad
    result = hash.map { |k, v| v + 1}

    # good
    result = hash.map { |_, v| v + 1 }
    ```

### 命名

> The only real difficulties in programming are cache invalidation and
> naming things. <br/>
> -- Phil Karlton
> 程序（运行）中唯一不一样的是无效的缓存和命名的事物（变量）。<br/>
> -- Phil Karlton

* 使用`snake_case`的形式给变量和方法命名。
* Snake case: punctuation is removed and spaces are replaced by single underscores. Normally the letters share the same case (either UPPER_CASE_EMBEDDED_UNDERSCORE or lower_case_embedded_underscore) but the case can be mixed
* 使用`CamelCase(駝峰式大小寫)`的形式给类和模块命名。(保持使用缩略首字母大写的方式如HTTP,
  RFC, XML)
* 使用`SCREAMING_SNAKE_CASE`给常量命名。
* 在表示断言的方法名（方法返回真或者假）的末尾添加一个问号（如Array#empty?）。
* 可能会造成潜在“危险”的方法名（如修改self或者在原处修改变量的方法，exit!等）应该在末尾添加一个感叹号。
* 当在短的块中使用`reduce`时，命名参数`|a, e|` (accumulator, element)。

    ```Ruby
    #Combines all elements of enum枚举 by applying a binary operation, specified by a block or a symbol that names a method or operator.
    # Sum some numbers
    (5..10).reduce(:+)                            #=> 45#reduce
    # Same using a block and inject
    (5..10).inject {|sum, n| sum + n }            #=> 45 #inject注入
    # Multiply some numbers
    (5..10).reduce(1, :*)                         #=> 151200
    # Same using a block
    (5..10).inject(1) {|product, n| product * n } #=> 151200
    ```

* 在定义二元操作符方法时，将其的参数取名为other。

    ```Ruby
    def +(other)
      # body omitted
    end
    ```
* `map`优先于`collect`，`find`优先于`detect`，`select`优先于`find_all`，`reduce`优先于`inject`，`size`优先于`length`。以上的规则并不绝定，如果使用后者能提高代码的可读性，那么尽管使用它们。这些对应的方法名（如collect，detect，inject）继承于SmallTalk语言，它们在其它语言中并不是很通用。鼓励使用select而不是find_all是因为select与reject一同使用时很不错，并且它的名字具有很好的自解释性。

## 注释

> Good code is its own best documentation. As you're about to add a
> comment, ask yourself, "How can I improve the code so that this
> comment isn't needed?" Improve the code and then document it to make
> it even clearer. <br/>
> -- Steve McConnell
> 好的代码在于它有好的文档。当你打算添加一个注释，问问自己，“我该做的是怎样提高代码质量，那么这个注释是不是不需要了？”提高代码并且给他们添加文档使得它更加简洁。<br/>
> -- Steve McConnell

* 写出自解释文档代码，然后忽略不工作的这部分。这不是说着玩。
* 注释长于一个单词则以大写开始并使用标点。使用一个空格将注释与符号隔开。Use [one
  space](http://en.wikipedia.org/wiki/Sentence_spacing) after periods.
* 避免多余的注释。

    ```Ruby
    # bad
    counter += 1 # increments counter by one
    ```

* 随时更新注释，没有注释比过期的注释更好。
* 不要为糟糕的代码写注释。重构它们，使它们能够“自解释”。(Do or do not - there is no try.)

## 注解


