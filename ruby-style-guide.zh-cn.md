# 序

> 风格可以用来区分从好到卓越。<br />
> -- Bozhidar Batsov
> 榜样很重要。<br/>
> -- Officer Alex J. Murphy / RoboCop


有一件事情总是困扰着，作为Ruby程序员的我 - python 开发者都有一个很棒的编程风格参考
([PEP-8](http://www.python.org/dev/peps/pep-0008/))，然而我们从没有一个官方的（公认）的 guide，文档化 Ruby 代码风格和最佳实践。而且我信赖这些风格（的作用）。我也相信很棒的 hacker 社区，比如 Ruby 社区，也应该有能力写出这梦寐以求的文档。

这份指南诞生于我们公司内部的 Ruby 编程准则(由值得你信赖的同志们编写)，我做正在做的工作基于这样的出发点： Ruby 社区的大多数成员会对我正在做的有兴趣这样的发点，并且这个世界上不需要一个公司内部的（编程）准则。一个面向 Ruby 编程的由社区驱动和社区认可一系列的实践，原则和风格形式是有益于大家的。

自从这个 guide（发表）以来，我收到了很多来自世界范围内 Ruby 社区的优秀的成员的回馈。感谢所有的建议和支持！集众家之力，我们可以创作出对每一个 Ruby 开发人员有益的资源。

补充，如果你正在使用 rails 你可能会希望查阅 [Ruby on Rails 3 Style Guide](https://github.com/bbatsov/rails-style-guide)。

# Ruby 风格指南

这个 Ruby 风格指南推荐（一些）最佳实践使得现实世界中的 Ruby 程序员可以写出能够被其他现实世界的 Ruby 程序员维护的代码。一个风格指南反映了真实世界的使用习惯，同时一个风格指南伴随着一个观点那就是它被一些人们抵制因为它可能会导致风险的产生甚至毫无用处 —— 无论它有多好。

这个指南被分为几个相关联的 rules 的几节。我会尝试给 rules 添加合理的解释（如果它被省略那么我假设它相当的明显了）。

我并没有列举所有的 rules - 它们大多数基于我作为一个专业的软件工程师的广泛生涯、回馈和来自Ruby社区成员的建议以及各种备受推崇的 Ruby 编程资源，例如 ["Programming Ruby 1.9"](http://pragprog.com/book/ruby3/programming-ruby-1-9)
和 ["The Ruby Programming Language"](http://www.amazon.com/Ruby-Programming-Language-David-Flanagan/dp/0596516177)。

很多地方的实践风格在 Ruby 社区没有一个明确的共识（sring 的字面引用，hash 里面的空格，点号在多行方法链的位置，等等 ）。在这样的场景中所有流行的风格都是被承认的并且它取决于你的选择和考虑。

这个指南仍然在工作进程中 - 一些 rules 缺乏例子，一些 rules 没有合适的例子来使得它们足够明了。在这期间一些问题将会提出 - just keep them in mind for now (以后将得到解决).

你可以使用 [Transmuter](https://github.com/TechnoGate/transmuter). 来生成指南的 PDF 或者 HTML 副本。

[RuboCop](https://github.com/bbatsov/rubocop) 是一个代码分析器, 它基于这个指南。

本指南的有下列语言的译文：

* [Chinese Simplified](https://github.com/JuanitoFatas/ruby-style-guide/blob/master/README-zhCN.md)
* [Chinese Traditional](https://github.com/JuanitoFatas/ruby-style-guide/blob/master/README-zhTW.md)
* [French](https://github.com/porecreat/ruby-style-guide/blob/master/README-frFR.md)
* [Japanese](https://github.com/fortissimo1997/ruby-style-guide/blob/japanese/README.ja.md)
* [Spanish](https://github.com/alemohamad/ruby-style-guide/blob/master/README-esLA.md)
* [Vietnamese](https://github.com/scrum2b/ruby-style-guide/blob/master/README-viVN.md)

## 目录表单

* [源代码布局](#源代码布局)
* [语法](#语法)
* [命名](#命名)
* [注释](#注释)
    * [注解](#注解)
* [类](#类)
* [异常](#异常)
* [集合](#集合)
* [字符串](#字符串)
* [正则表达式](#正则表达式)
* [百分号和字面值](#百分号和字面值)
* [元编程](#元编程)
* [杂项](#杂项)
* [工具](#工具)

## 源代码布局

> 所有风格都又丑又难读，自己的除外。几乎人人都这样想。
> 把 “自己的除外”拿掉，他们或许是对的...
> -- Jerry Coffin (on indentation缩进)

* 使用 `UTF-8` 作为源文件编码。
* 每个缩进级别使用两个 **spaces** （又名软 tabs）. 不要硬 tabs

    ```Ruby
    # bad - four spaces
    def some_method
        do_something
    end

    # good
    def some_method
      do_something
    end
    ```

* 使用 Unix-风格 换行符。(*BSD/Solaris/Linux/OSX 用户被为默认涵盖，Windows 用户必须特别小心.)
> \n是换行，英文是LineFeed，ASCII码是0xA。
> \r是回车，英文是Carriage Return ,ASCII码是0xD。
> windows下enter是 \n\r,unix下是\n,mac下是\r
    * 如果你正在使用 Git 你可能会想要添加下面的配置设置来保护你的项目（避免）Windows 蔓延过来的换行符:

    ```bash
    $ git config --global core.autocrlf true
    ```

* 不用使用 `;` 来分割语句和表达式。以此推论 - 一行使用一个表达式
* Don't use `;` to separate statements and expressions. As a
  corollary - use one expression per line.

    ```Ruby
    # bad
    puts 'foobar'; # superfluous semicolon

    puts 'foo'; puts 'bar' # two expression on the same line

    # good
    puts 'foobar'

    puts 'foo'
    puts 'bar'

    puts 'foo', 'bar' # this applies to puts in particular
    ```

* 对于没有内容的类定义，尽可能使用单行类定义形式.

    ```Ruby
    # bad
    class FooError < StandardError
    end

    # okish
    class FooError < StandardError; end

    # good
    FooError = Class.new(StandardError)
    ```

* 避免单行方法。即便还是会受到一些人的欢迎，这里还是会有一些古怪的语法用起来很容易犯错.
  无论如何 - 应该一行不超过一个单行方法.

    ```Ruby
    # bad
    def too_much; something; something_else; end

    # okish - notice that the first ; is required
    def no_braces_method; body end

    # okish - notice that the second ; is optional
    def no_braces_method; body; end

    # okish - valid syntax, but no ; make it kind of hard to read
    def some_method() body end

    # good
    def some_method
      body
    end
    ```

    空方法是这个规则的例外。

    ```Ruby
    # good
    def no_op; end
    ```

* 操作符旁的空格，在逗号，冒号和分号后；在 `{` 旁和在 `}` 之前，大多数空格可能对 Ruby 解释（代码）无关，但是它的恰当使用是让代码变得易读的关键。

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

    `{` 和 `}` 值得额外的澄清，自从它们被用于 块 和 hash 字面量，以及以表达式的形式嵌入字符串。
    对于 hash 字面量两种风格是可以接受的。

    ```Ruby
    # good - space after { and before }
    { one: 1, two: 2 }

    # good - no space after { and before }
    {one: 1, two: 2}
    ```

    第一种稍微更具可读性（并且争议的是一般在 Ruby 社区里面更受欢迎）。
    第二种可以增加了 块 和 hash 可视化的差异。
    无论你选哪一种都行 - 但是最好保持一致。

    目前对于嵌入表达式，也有两个选择：

    ```Ruby
    # good - no spaces
    "string#{expr}"

    # ok - arguably more readable
    "string#{ expr }"
    ```

    第一种风格极为流行并且通常建议你与之靠拢。第二种，在另一方面，（有争议）更具可读性。
    如同 hash - 选取一个风格并且保持一致。

* 没有空格 `(`, `[`之后或者 `]`, `)`之前。

    ```Ruby
    some(arg).other
    [1, 2, 3].length
    ```

* `!` 之后没有空格 .

    ```Ruby
    # bad
    ! something

    # good
    !something
    ```

* `when`和`case` 缩进深度一致。我知道很多人会不同意这点，但是它是"The Ruby Programming Language" 和 "Programming Ruby"中公认的风格。

    ```Ruby
    # bad
    case
      when song.name == 'Misty'
        puts 'Not again!'
      when song.duration > 120
        puts 'Too long!'
      when Time.now.hour > 21
        puts "It's too late"
      else
        song.play
    end

    # good
    case
    when song.name == 'Misty'
      puts 'Not again!'
    when song.duration > 120
      puts 'Too long!'
    when Time.now.hour > 21
      puts "It's too late"
    else
      song.play
    end
    ```
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
    ```

* 当赋值一个条件表达式的结果给一个变量时，保持分支的缩排在同一层。

    ```Ruby
    # bad - pretty convoluted
    kind = case year
    when 1850..1889 then 'Blues'
    when 1890..1909 then 'Ragtime'
    when 1910..1929 then 'New Orleans Jazz'
    when 1930..1939 then 'Swing'
    when 1940..1950 then 'Bebop'
    else 'Jazz'
    end

    result = if some_cond
      calc_something
    else
      calc_something_else
    end

    # good - it's apparent what's going on
    kind = case year
           when 1850..1889 then 'Blues'
           when 1890..1909 then 'Ragtime'
           when 1910..1929 then 'New Orleans Jazz'
           when 1930..1939 then 'Swing'
           when 1940..1950 then 'Bebop'
           else 'Jazz'
           end

    result = if some_cond
               calc_something
             else
               calc_something_else
             end

    # good (and a bit more width efficient)
    kind =
      case year
      when 1850..1889 then 'Blues'
      when 1890..1909 then 'Ragtime'
      when 1910..1929 then 'New Orleans Jazz'
      when 1930..1939 then 'Swing'
      when 1940..1950 then 'Bebop'
      else 'Jazz'
      end

    result =
      if some_cond
        calc_something
      else
        calc_something_else
      end
    ```

* 在方法定义之间使用空行并且一个方法根据逻辑段来隔开。

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

* 避免在一个方法调用的最后一个参数有逗号，特别是当参数不在另外一行。

    ```Ruby
    # bad - easier to move/add/remove parameters, but still not preferred
    some_method(
                 size,
                 count,
                 color,
               )

    # bad
    some_method(size, count, color, )

    # good
    some_method(size, count, color)
    ```

* 当给方法的参数赋默认值时，在 `=` 两边使用空格：

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

    虽然几本 Ruby 书建议用第一个风格，不过第二个风格在实践中更为常见（并可争议地可读性更高一点）。

* 避免在不需要的时候使用行继续符 `\` 。实践中，
  除非用于连接字符串, 否则避免在任何情况下使用行继续符。

    ```Ruby
    # bad
    result = 1 - \
             2

    # good (but still ugly as hell)
    result = 1 \
             - 2

    long_string = 'First part of the long string' \
                  ' and second part of the long string'
    ```

* Adopt a consistent multi-line method chaining style. There are two
  popular styles in the Ruby community, both of which are considered
  good - leading `.` (Option A) and trailing `.` (Option B).

* 采用连贯的多行方法链式风格。在 Ruby 社区有两种受欢迎的风格，它们都被认为很好
  \- `.` 开头(选项 A) 和 尾随 `.` (选项 B) 。

    * **(选项 A)** 当一个链式方法调用需要在另一行继续时，将 `.` 放在第二行。

        ```Ruby
        # bad - need to consult first line to understand second line
        one.two.three.
          four

        # good - it's immediately clear what's going on the second line
        one.two.three
          .four
        ```
    * **(选项 B)** 当在另一行继续一个链式方法调用，将 `.` 放在第一行来识别要继续的表达式。

        ```Ruby
        # bad - need to read ahead to the second line to know that the chain continues
        one.two.three
          .four

        # good - it's immediately clear that the expression continues beyond the first line
        one.two.three.
          four
        ```
    在[这里](https://github.com/bbatsov/ruby-style-guide/pull/176)可以发现有关这两个另类风格的优点的讨论。

* 如果一个方法调用的跨度超过了一行，对它们齐的参数。当参数对齐因为行宽限制而不合适，
  在第一行之后单缩进也是可以接受的。

    ```Ruby
    # starting point (line is too long)
    def send_mail(source)
      Mailer.deliver(to: 'bob@example.com', from: 'us@example.com', subject: 'Important message', body: source.text)
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

    # good (normal indent)
    def send_mail(source)
      Mailer.deliver(
        to: 'bob@example.com',
        from: 'us@example.com',
        subject: 'Important message',
        body: source.text
      )
    end
    ```

* 对齐多行跨度的 array literals 的元素。

    ```Ruby
    # bad - single indent
    menu_item = ['Spam', 'Spam', 'Spam', 'Spam', 'Spam', 'Spam', 'Spam', 'Spam',
      'Baked beans', 'Spam', 'Spam', 'Spam', 'Spam', 'Spam']

    # good
    menu_item = [
      'Spam', 'Spam', 'Spam', 'Spam', 'Spam', 'Spam', 'Spam', 'Spam',
      'Baked beans', 'Spam', 'Spam', 'Spam', 'Spam', 'Spam'
    ]

    # good
    menu_item =
      ['Spam', 'Spam', 'Spam', 'Spam', 'Spam', 'Spam', 'Spam', 'Spam',
       'Baked beans', 'Spam', 'Spam', 'Spam', 'Spam', 'Spam']
    ```

* 大数值添加下划线来提高它们的可读性。

    ```Ruby
    # bad - how many 0s are there?
    num = 1000000

    # good - much easier to parse for the human brain
    num = 1_000_000
    ```

* 使用 RDoc 以及它的惯例来撰写 API 文档。注解区块及 `def` 不要用空行隔开。
* 每一行限制在 80 个字符内。
* 避免行尾空格。
* 不要使用区块注释。它们不能由空白引导（=begin 必须顶头开始），并且不如普通注释容易辨认。

    ```Ruby
    # bad
    == begin
    comment line
    another comment line
    == end

    # good
    # comment line
    # another comment line
    ```

* 在 API 文档中使用 RDoc和它的公约。不要在注释代码块和`def`之间加入空行。
* 保持每一行少于80字符。
* 避免尾随空格。

## 语法

* 使用 `::` 引用常量（包括类和模块）和构造器 (比如 `Array()` 或者 `Nokogiri::HTML()`)。
  永远不要使用 `::` 来调用方法。

    ```Ruby
    # bad
    SomeClass::some_method
    some_object::some_method

    # good
    SomeClass.some_method
    some_object.some_method
    SomeModule::SomeClass::SOME_CONST
    SomeModule::SomeClass()
    ```

* 使用括号将`def`的参数括起来。当方法不接收任何参数的时候忽略括号。

     ```Ruby
     # bad
     def some_method()
       # body omitted
     end

     # good
     def some_method
       # body omitted
     end

     # bad
     def some_method_with_arguments arg1, arg2
       # body omitted
     end

     # good
     def some_method_with_arguments(arg1, arg2)
       # body omitted
     end
     ```

* 从来不要使用 `for`， 除非你知道使用它的准确原因。大多数时候迭代器都可以用来替`for`。`for` 是由一组 `each` 实现的 (因此你正间接添加了一级)，但是有一个小道道 - `for`并不包含一个新的 scope (不像 `each`)并且在它的块中定义的变量在外面也是可以访问的。

    ```Ruby
    arr = [1, 2, 3]

    # bad
    for elem in arr do
      puts elem
    end

    # note that elem is accessible outside of the for loop
    elem #=> 3

    # good
    arr.each { |elem| puts elem }

    # elem is not accessible outside each's block
    elem #=> NameError: undefined local variable or method `elem'
    ```

* 在多行的 `if/unless` 中坚决不要使用 `then`。

    ```Ruby
    # bad
    if some_condition then
      # body omitted
    end

    # good
    if some_condition
      # body omitted
    end
    ```

* 在多行的 `if/unless` 总是把条件放在与 `if/unless` 的同一行。

    ```Ruby
    # bad
    if
      some_condition
      do_something
      do_something_else
    end

    # good
    if some_condition
      do_something
      do_something_else
    end
    ```

* 喜欢三元操作运算（`?:`）超过`if/then/else/end`结构。
  它更加普遍而且明显的更加简洁。

    ```Ruby
    # bad
    result = if some_condition then something else something_else end

    # good
    result = some_condition ? something : something_else
    ```

* 使用一个表达式在三元操作运算的每一个分支下面只使用一个表达式。也就是说三元操作符不要被嵌套。在这样的情形中宁可使用 `if/else`。

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

* 不要使用 `if x: ...` - 它在Ruby 1.9中已经移除。使用三元操作运算代替。

    ```Ruby
    # bad
    result = if some_condition then something else something_else end

    # good
    result = some_condition ? something : something_else
    ```

* 不要使用 `if x; ...`。使用三元操作运算代替。

* 利用 `if` and `case` 是表达式这样的事实它们返回一个结果。

    ```Ruby
    # bad
    if condition
      result = x
    else
      result = y
    end

    # good
    result =
      if condition
        x
      else
        y
      end
    ```

* 在 one-line cases 的时候使用 `when x then ...`。替代的语法`when x: xxx`已经在Ruby 1.9中移除。


* 不要使用`when x; ...`。查看上面的规则。

* 使用 `!` 替代 `not`.

    ```Ruby
    # 差 - 因为操作符有优先级，需要用括号。
    x = (not something)

    # good
    x = !something
    ```

* 避免使用 `!!`.

    ```Ruby
    # bad
    x = 'test'
    # obscure nil check
    if !!x
      # body omitted
    end

    x = false
    # double negation is useless on booleans
    !!x # => false

    # good
    x = 'test'
    unless x.nil?
      # body omitted
    end
    ```

* The `and` and `or` keywords are banned. It's just not worth
  it. Always use `&&` and `||` instead.
* `and` 和 `or` 这两个关键字被禁止使用了。它名不符实。总是使用 `&&` 和 `||` 来取代。

    ```Ruby
    # bad
    # boolean expression
    if some_condition and some_other_condition
      do_something
    end

    # control flow
    document.saved? or document.save!

    # good
    # boolean expression
    if some_condition && some_other_condition
      do_something
    end

    # control flow
    document.saved? || document.save!
    ```

* 避免多行的 `? : `（三元操作符）；使用 `if/unless` 来取代。

* 单行主体喜欢使用 `if/unless` 修饰符。另一个好方法是使用 `&&/||` 控制流程。

    ```Ruby
    # bad
    if some_condition
      do_something
    end

    # good
    do_something if some_condition

    # another good option
    some_condition && do_something
    ```

* 布尔表达式使用`&&/||`, `and/of`用于控制流程。（经验Rule:如果你必须使用额外的括号（表达逻辑），那么你正在使用错误的的操作符。）

    ```Ruby
    # boolean expression
    if some_condition && some_other_condition
      do_something
    end

    # control flow
    document.save? or document.save!
    ```

* 避免多行`?:`(三元操作运算)，使用 `if/unless` 替代。

* 在单行语句的时候喜爱使用 `if/unless` 修饰符。另一个好的选择就是使 `and/of` 来做流程控制。

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

* 永远不要使用 `unless` 和 `else` 组合。将它们改写成肯定条件。

    ```Ruby
    # bad
    unless success?
      puts 'failure'
    else
      puts 'success'
    end

    # good
    if success?
      puts 'success'
    else
      puts 'failure'
    end
    ```

* 不用使用括号包含 `if/unless/while` 的条件。

    ```Ruby
    # bad
    if (x > 10)
      # body omitted
    end

    # good
    if x > 10
      # body omitted
    end
    ```

* 在多行 `while/until` 中不要使用 `while/until condition do` 。

    ```Ruby
    # bad
    while x > 5 do
      # body omitted
    end

    until x > 5 do
      # body omitted
    end

    # good
    while x > 5
      # body omitted
    end

    until x > 5
      # body omitted
    end
    ```

* 当你有单行主体时，尽量使用 `while/until` 修饰符。

    ```Ruby
    # bad
    while some_condition
      do_something
    end

    # good
    do_something while some_condition
    ```

* 否定条件判断尽量使用 `until` 而不是 `while` 。

    ```Ruby
    # bad
    do_something while !some_condition

    # good
    do_something until some_condition
    ```

* 循环后条件判断使用 `Kernel#loop` 和 `break`，而不是 `begin/end/until` 或者 `begin/end/while`。

   ```Ruby
   # bad
   begin
     puts val
     val += 1
   end while val < 0

   # good
   loop do
     puts val
     val += 1
     break unless val < 0
   end
   ```

* 忽略围绕内部 DSL 方法参数的括号 (如：Rake, Rails, RSpec)，Ruby 中带有 "关键字" 状态的方法（如：`attr_reader`，`puts`）以及属性存取方法。所有其他的方法调用使用括号围绕参数。

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

    bowling.score.should == 0
    ```

* 忽略隐式选项 hash 外部的花括号。

    ```Ruby
    # bad
    user.set({ name: 'John', age: 45, permissions: { read: true } })

    # good
    user.set(name: 'John', age: 45, permissions: { read: true })
    ```

* 内部 DSL 方法的外部括号和大括号。

    ```Ruby
    class Person < ActiveRecord::Base
      # bad
      validates(:name, { presence: true, length: { within: 1..10 } })

      # good
      validates :name, presence: true, length: { within: 1..10 }
    end
    ```

* 方法调用不需要参数，那么忽略圆括号。

    ```Ruby
    # bad
    Kernel.exit!()
    2.even?()
    fork()
    'test'.upcase()

    # good
    Kernel.exit!
    2.even?
    fork
    'test'.upcase
    ```


* 在单行代码块的时候宁愿使用 `{...}` 而不是 `do...end`。避免在多行代码块使用 `{...}` (多行链式通常变得非常丑陋)。通常使用 `do...end` 来做 `流程控制` 和 `方法定义` (例如 在 Rakefiles 和某些 DSLs 中)。避免在链式调用中使用 `do...end`。

    ```Ruby
    names = ['Bozhidar', 'Steve', 'Sarah']

    # bad
    names.each do |name|
      puts name
    end

    # good
    names.each { |name| puts name }

    # bad
    names.select do |name|
      name.start_with?('S')
    end.map { |name| name.upcase }

    # good
    names.select { |name| name.start_with?('S') }.map { |name| name.upcase }
    ```

    有人会争论多行链式看起来和使用 `{...}` 一样工作，但是他们问问自己 - 这样的代码真的有可读性码并且为什么代码块中的内容不能被提取到美丽的方法中。

* Consider using explicit block argument to avoid writing block
  literal that just passes its arguments to another block. Beware of
  the performance impact, though, as the block gets converted to a
  Proc.
  考虑使用明确的块参数来避免写入的块字面量仅仅传递参数的给另一个块。小心性能的影响，即使，
  块被转换成了 Proc。

    ```Ruby
    require 'tempfile'

    # bad
    def with_tmp_dir
      Dir.mktmpdir do |tmp_dir|
        Dir.chdir(tmp_dir) { |dir| yield dir }  # block just passes arguments
      end
    end

    # good
    def with_tmp_dir(&block)
      Dir.mktmpdir do |tmp_dir|
        Dir.chdir(tmp_dir, &block)
      end
    end

    with_tmp_dir do |dir|
      puts "dir is accessible as parameter and pwd is set: #{dir}"
    end
    ```

* 避免在不需要流的控制使用 `return`。

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


* 避免在不需要的地方使用 `self`(它仅仅在调用一些 `self` 做写访问的时候需要)(It is only required when calling a self write accessor.)

    ```Ruby
    # bad
    def ready?
      if self.last_reviewed_at > self.last_updated_at
        self.worker.update(self.content, self.options)
        self.status = :in_progress
      end
      self.status == :verified
    end

    # good
    def ready?
      if last_reviewed_at > last_updated_at
        worker.update(content, options)
        self.status = :in_progress
      end
      status == :verified
    end
    ```

* 作为一个必然的结果，避免将方法（参数）放于局部变量阴影之下除非它们是相等的。

    ```Ruby
    class Foo
      attr_accessor :options

      # ok
      def initialize(options)
        self.options = options
        # both options and self.options are equivalent here
      end

      # bad
      def do_something(options = {})
        unless options[:when] == :later
          output(self.options[:message])
        end
      end

      # good
      def do_something(params = {})
        unless params[:when] == :later
          output(options[:message])
        end
      end
    end
    ```

* 不要在条件表达式里使用 `=` （赋值）的返回值，除非条件表达式在圆括号内被赋值。
  这是一个相当流行的 ruby 方言，有时被称为 *safe assignment in condition*。

    ```Ruby
    # bad (+ a warning)
    if v = array.grep(/foo/)
      do_something(v)
      ...
    end

    # good (MRI would still complain, but RuboCop won't)
    if (v = array.grep(/foo/))
      do_something(v)
      ...
    end

    # good
    v = array.grep(/foo/)
    if v
      do_something(v)
      ...
    end
    ```

* 在任何可以的地方使用快捷的 `self assignment` 操作符。

    ```Ruby
    # bad
    x = x + y
    x = x * y
    x = x**y
    x = x / y
    x = x || y
    x = x && y

    # good
    x += y
    x *= y
    x **= y
    x /= y
    x ||= y
    x &&= y
    ```

* 只有在变量没有被初始化的时候使用 `||=` 来初始化变量。

    ```Ruby
    # set name to Vozhidar, only if it's nil or false
    name ||= 'Bozhidar'
    ````

* 不要使用`||=`来初始化布尔变量。（想想如果当前值为`false`的时候会发生什么。）

    ```Ruby
    # bad - would set enabled to true even if it was false
    enable ||= true

    # good
    enabled = true if enabled.nil?
    ```

* 使用 `&&=` 来预处理变量不确定是否存在的变量。使用 `&&=` 仅仅在（变量）存在的时候
  才会改变值，除去了使用 `if` 来检查它的存在性。

    ```Ruby
    # bad
    if something
      something = something.downcase
    end

    # bad
    something = something ? nil : something.downcase

    # ok
    something = something.downcase if something

    # good
    something = something && something.downcase

    # better
    something &&= something.downcase
    ```

* 避免全等（case equality）`===` 操作符的使用。从名称可知，这是 `case` 表达式的隐式使用并且在 `case` 语句外的场合使用会产生难以理解的代码。

    ```Ruby
    # bad
    Array === something
    (1..100) === 7
    /something/ === some_string

    # good
    something.is_a?(Array)
    (1..100).include?(7)
    some_string =~ /something/
    ```

* 避免使用 Perl 的指定变量风格（比如，`$:`，`$;` 等等。）。它们相当神秘，不鼓励在单行代码之外使用它们。
  使用 `English` 库提供的友好别名。

    ```Ruby
    # bad
    $:.unshift File.dirname(__FILE__)

    # good
    require 'English'
    $LOAD_PATH.unshift File.dirname(__FILE__)
    ```

* 从来不要在方法名和（参数）开括号之间使用空格。

    ```Ruby
    # bad
    f (3+2) + 1

    # good
    f(3 + 2) +1
    ```

* 如果方法的第一个参数以开括号开始，通常使用括号把它们全部括起来。例如`f((3 + 2) + 1)`。

* 通常使用 `-w` 选项运行 Ruby 解释器，在你忘记上面所诉规则，ruby 将会提示你。

* 定义单行块使用新的 lambda 语法。定义多行块中使用 `lambda` 方法。

    ```Ruby
    # bad
    l = lambda { |a, b| a + b }
    l.call(1, 2)

    # correct, but looks extremely awkward
    l = ->(a, b) do
      tmp = a * 7
      tmp * b / 50
    end

    # good
    l = ->(a, b) { a + b }
    l.call(1, 2)

    l = lambda do |a, b|
      tmp = a * 7
      tmp * b / 50
    end
    ```

* 用 `proc` 而不是 `Proc.new`。

    ```Ruby
    # bad
    p = Proc.new { |n| puts n }

    # good
    p = proc { |n| puts n }
    ```

* 匿名方法 和 块 用 `proc.call()` 而不是 `proc[]` 或 `proc.()`。

    ```Ruby
    # bad - looks similar to Enumeration access
    l = ->(v) { puts v }
    l[1]

    # also bad - uncommon syntax
    l = ->(v) { puts v }
    l.(1)

    # good
    l = ->(v) { puts v }
    l.call(1)
    ```

* 未使用的块参数和局部变量使用 `_`。它也可以接受通过 `_` 来使用（即使它有少了些描述性）。
  这个惯例由 Ruby 解释器以及 RuboCop 这样的工具组织其将会抑制它们的未使用参数警告。

    ```Ruby
    # bad
    result = hash.map { |k, v| v + 1 }

    def something(x)
      unused_var, used_var = something_else(x)
      # ...
    end

    # good
    result = hash.map { |_k, v| v + 1 }

    def something(x)
      _unused_var, used_var = something_else(x)
      # ...
    end

    # good
    result = hash.map { |_, v| v + 1 }

    def something(x)
      _, used_var = something_else(x)
      # ...
    end
    ```

* 使用 `$stdout/$stderr/$stdin` 而不是 `STDOUT/STDERR/STDIN`。`STDOUT/STDERR/STDIN` 是常量，虽然在 Ruby 中是可以给常量重新赋值的（可能是重定向到某个流），但解释器会警告如果你执意这样。

* 使用 `warn` 而不是 `$stderr.puts`。除了更加清晰简洁，如果你需要的话，
  `warn` 还允许你抑制（suppress）警告（通过 `-W0` 将警告级别设为 0）。

* 倾向使用 `sprintf` 和它的别名 `format` 而不是相当隐晦的 `String#%` 方法.

    ```Ruby
    # bad
    '%d %d' % [20, 10]
    # => '20 10'

    # good
    sprintf('%d %d', 20, 10)
    # => '20 10'

    # good
    sprintf('%{first} %{second}', first: 20, second: 10)
    # => '20 10'

    format('%d %d', 20, 10)
    # => '20 10'

    # good
    format('%{first} %{second}', first: 20, second: 10)
    # => '20 10'
    ```

* 倾向使用 `Array#join` 而不是相当隐晦的使用字符串作参数的 `Array#*`。


    ```Ruby
    # bad
    %w(one two three) * ', '
    # => 'one, two, three'

    # good
    %w(one two three).join(', ')
    # => 'one, two, three'
    ```

* 当处理你希望像 Array 那样对待的变量，但是你不确定它是一个数组时，
  使用 `[*var]` or `Array()` 而不是显式的 `Array` 检查。

    ```Ruby
    # bad
    paths = [paths] unless paths.is_a? Array
    paths.each { |path| do_something(path) }

    # good
    [*paths].each { |path| do_something(path) }

    # good (and a bit more readable)
    Array(paths).each { |path| do_something(path) }
    ```

* 尽量使用范围或 `Comparable#between?` 来替换复杂的逻辑比较。

    ```Ruby
    # bad
    do_something if x >= 1000 && x <= 2000

    # good
    do_something if (1000..2000).include?(x)

    # good
    do_something if x.between?(1000, 2000)
    ```

* 尽量用谓词方法而不是使用 `==`。比较数字除外。

    ```Ruby
    # bad
    if x % 2 == 0
    end

    if x % 2 == 1
    end

    if x == nil
    end

    # good
    if x.even?
    end

    if x.odd?
    end

    if x.nil?
    end

    if x.zero?
    end

    if x == 0
    end
    ```

* 避免使用 `BEGIN` 区块。

* 使用 `Kernel#at_exit` 。永远不要用 `END` 区块。

    ```ruby
    # bad

    END { puts 'Goodbye!' }

    # good

    at_exit { puts 'Goodbye!' }
    ```

* 避免使用 flip-flops 。

* 避免使用嵌套的条件来控制流程。
  当你可能断言不合法的数据，使用一个防御语句。一个防御语句是一个在函数顶部的条件声明，这样如果数据不合法就能尽快的跳出函数。

    ```Ruby
    # bad
      def compute_thing(thing)
        if thing[:foo]
          update_with_bar(thing)
          if thing[:foo][:bar]
            partial_compute(thing)
          else
            re_compute(thing)
          end
        end
      end

    # good
      def compute_thing(thing)
        return unless thing[:foo]
        update_with_bar(thing[:foo])
        return re_compute(thing) unless thing[:foo][:bar]
        partial_compute(thing)
      end
    ```
### 命名

> The only real difficulties in programming are cache invalidation and
> naming things. <br/>
> -- Phil Karlton
> 程式设计的真正难题是替事物命名及使缓存失效。<br/>
> -- Phil Karlton

* 用英语命名标识符。

    ```Ruby
    # bad - identifier using non-ascii characters
    заплата = 1_000

    # bad - identifier is a Bulgarian word, written with Latin letters (instead of Cyrillic)
    zaplata = 1_000

    # good
    salary = 1_000
    ```

* 使用`snake_case`的形式给变量和方法命名。

    ```Ruby
    # bad
    :'some symbol'
    :SomeSymbol
    :someSymbol

    someVar = 5

    def someMethod
      ...
    end

    def SomeMethod
     ...
    end

    # good
    :some_symbol

    def some_method
      ...
    end
    ```

* Snake case: punctuation is removed and spaces are replaced by single underscores. Normally the letters share the same case (either UPPER_CASE_EMBEDDED_UNDERSCORE or lower_case_embedded_underscore) but the case can be mixed

* 使用`CamelCase(駝峰式大小寫)`的形式给类和模块命名。(保持使用缩略首字母大写的方式如HTTP,
  RFC, XML)

    ```Ruby
    # bad
    class Someclass
      ...
    end

    class Some_Class
      ...
    end

    class SomeXml
      ...
    end

    # good
    class SomeClass
      ...
    end

    class SomeXML
      ...
    end
    ```

* 使用 `snake_case` 来命名文件, 例如 `hello_world.rb`。

* 以每个源文件中仅仅有单个 class/module 为目的。按照 class/module 来命名文件名，但是替换 CamelCase 为 snake_case。

* 使用`SCREAMING_SNAKE_CASE`给常量命名。

    ```Ruby
    # bad
    SomeConst = 5

    # good
    SOME_CONST = 5
    ```

* 在表示判断的方法名（方法返回真或者假）的末尾添加一个问号（如Array#empty?）。
  方法不返回一个布尔值，不应该以问号结尾。
* 可能会造成潜在“危险”的方法名（如修改 `self`或者 参数的方法，`exit!` (不是像 `exit` 执行完成项)等）应该在末尾添加一个感叹号如果这里存在一个该 *危险* 方法的安全版本。

    ```Ruby
    # bad - there is not matching 'safe' method
    class Person
      def update!
      end
    end

    # good
    class Person
      def update
      end
    end

    # good
    class Person
      def update!
      end

      def update
      end
    end
    ```

* 如果可能的话，根据危险方法（bang）来定义对应的安全方法（non-bang）。

    ```Ruby
    class Array
      def flatten_once!
        res = []

        each do |e|
          [*e].each { |f| res << f }
        end

        replace(res)
      end

      def flatten_once
        dup.flatten_once!
      end
    end
    ```

* 当在短的块中使用 `reduce` 时，命名参数 `|a, e|` (accumulator, element)。

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

* 在定义二元操作符时，把参数命名为 `other` （`<<` 与 `[]` 是这条规则的例外，因为它们的语义不同）。

    ```Ruby
    def +(other)
      # body omitted
    end
    ```
* `map` 优先于 `collect`，`find` 优先于 `detect`，`select` 优先于 `find_all`，`reduce` 优先于`inject`，`size` 优先于 `length`。以上的规则并不绝定，如果使用后者能提高代码的可读性，那么尽管使用它们。有押韵的方法名（如 `collect`，`detect`，`inject`）继承于 SmallTalk 语言，它们在其它语言中并不是很通用。鼓励使用 `select` 而不是 `find_all` 是因为 `select` 与 `reject` 一同使用时很不错，并且它的名字具有很好的自解释性。

* 不要使用 `count` 作为 `size` 的替代。对于 `Enumerable` 的 `Array` 以外的对象将会迭代整个集合来
  决定它的尺寸。


    ```Ruby
    # bad
    some_hash.count

    # good
    some_hash.size
    ```

* 倾向使用 `flat_map` 而不是 `map` + `flatten` 的组合。
  这并不适用于深度大于 2 的数组，举个例子，如果 `users.first.songs == ['a', ['b', 'c']]` ，则使用 `map + flatten` 的组合，而不是使用 `flat_map` 。
  `flat_map` 将数组变平坦一个层级，而 `flatten` 会将整个数组变平坦。

    ```Ruby
    # bad
    all_songs = users.map(&:songs).flatten.uniq

    # good
    all_songs = users.flat_map(&:songs).uniq
    ```

* 使用 `reverse_each` 代替 `reverse.each`。`reverse_each` 不会分配一个新数组并且这是好事。

    ```Ruby
    # bad
    array.reverse.each { ... }

    # good
    array.reverse_each { ... }
    ```


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

* 注解应该写在紧接相关代码的上方。
* 注解关键字后跟一个冒号和空格，然后是描述问题的记录。
* 如果需要多行来描述问题，随后的行需要在`#`后面缩进两个空格。

    ```Ruby
    def bar
      # FIXME: This has crashed occasionally since v3.2.1. It may
      #  be related to the BarBazUtil upgrade.
      baz(:quux)
    end

* 如果问题相当明显，那么任何文档就多余了，注解也可以（违规的）在行尾而没有任何备注。这种用法不应当在一般情况下使用，也不应该是一个 rule。

    ```Ruby
    def bar
      sleep 100 # OPTIMIZE
    end
    ```

* 使用`TODO`来备注缺失的特性或者在以后添加的功能。
* 使用`FIXME`来备注有问题需要修复的代码。
* 使用`OPTIMIZE`来备注慢的或者低效的可能引起性能问题的代码。
* 使用`HACK`来备注那些使用问题代码的地方可能需要重构。
* 使用`REVIEW`来备注那些需要反复查看确认工作正常的代码。例如：`REVIEW: 你确定客户端是怎样正确的完成 X 的吗？`
* 使用其他自定义的关键字如果认为它是合适的，但是确保在你的项目的`README`或者类似的地方注明。

## 类

* 在设计类层次的时候确保他们符合[Liskov Substitution Principle](http://en.wikipedia.org/wiki/Liskov_substitution_principle)原则。(译者注: LSP原则大概含义为: 如果一个函数中引用了 `父类的实例`, 则一定可以使用其子类的实例替代, 并且函数的基本功能不变. (虽然功能允许被扩展))
>Liskov替换原则：子类型必须能够替换它们的基类型 <br/>
> 1. 如果每一个类型为T1的对象o1，都有类型为T2的对象o2，使得以T1定义的所有程序P在所有的对象o1都代换为o2时,程序P的行为没有变化，那么类型T2是类型T1的子类型。 <br/>
> 2. 换言之，一个软件实体如果使用的是一个基类的话，那么一定适用于其子类，而且它根本不能察觉出基类对象和子类对象的区别。只有衍生类替换基类的同时软件实体的功能没有发生变化，基类才能真正被复用。 <br/>
> 3. 里氏代换原则由Barbar Liskov(芭芭拉.里氏)提出，是继承复用的基石。 <br/>
> 4. 一个继承是否符合里氏代换原则，可以判断该继承是否合理（是否隐藏有缺陷）。

* 努力使你的类尽可能的健壮[SOLID](http://en.wikipedia.org/wiki/SOLID_(object-oriented_design\))。
* 总是为你自己的类提供to_s方法, 用来表现这个类（实例）对象包含的对象.

    ```Ruby
    class Person
      attr_reader :first_name, :last_name

      def initialize(first_name, last_name)
        @first_name = first_name
        @last_name = last_name
      end

      def to_s
        "#@first_name #@last_name"
      end
    end
    ```

* 使用`attr`功能功能成员来定义各个实例变量的访问器或者修改器方法。

    ```Ruby
    # bad
    class Person
      def initialize(first_name, last_name)
        @first_name = first_name
        @last_name = last_name
      end

      def first_name
        @first_name
      end

      def last_name
        @last_name
      end
    end

    # good
    class Person
      attr_reader :first_name, :last_name

      def initialize(first_name, last_name)
        @first_name = first_name
        @last_name = last_name
      end
    end
    ```

* 考虑使用 `Struct.new`, 它可以定义一些琐碎的 `accessors`,
`constructor`（构造函数） 和 `comparison`（比较） 操作。

    ```Ruby
    # good
    class Person
      attr_reader :first_name, :last_name

      def initialize(first_name, last_name)
        @first_name = first_name
        @last_name = last_name
      end
    end

    # better
    class Person < Struct.new(:first_name, :last_name)
    end
    ````

* 考虑添加工厂方法来提供灵活的方法来创建实际类实例。

    ```Ruby
    class Person
      def self.create(potions_hash)
        # body omitted
      end
    end
    ```

* 鸭子类型（[duck-typing](http://en.wikipedia.org/wiki/Duck_typing)）优于继承。

    ```Ruby
    # bad
    class Animal
      # abstract method
      def speak
      end
    end

    # extend superclass
    class Duck < Animal
      def speak
        puts 'Quack! Quack'
      end
    end

    # extend superclass
    class Dog < Animal
      def speak
        puts 'Bau! Bau!'
      end
    end

    # good
    class Duck
      def speak
        puts 'Quack! Quack'
      end
    end

    class Dog
      def speak
        puts 'Bau! Bau!'
      end
    end
    ```

* 避免使用类变量（`@@`）因为他们讨厌的继承习惯（在子类中也可以修改父类的类变量）。

    ```Ruby
    class Parent
      @@class_var = 'parent'

      def self.print_class_var
        puts @@class_var
      end
    end

    class Child < Parent
      @@class_var = 'child'
    end

    Parent.print_class_var # => will print "child"
    ```

    正如上例看到的, 所有的子类共享类变量, 并且可以直接修改类变量,此时使用类实例变量是更好的主意.

* 根据方法的用途为他们分配合适的可见度( `private`, `protected` )，不要让所有的方法都是 `public` (这是默认设定)。这是 *Ruby* 不是 *Python*。
* `public`, `protected`, 和 `private` 等可见性关键字应该和其（指定）的方法具有相同的缩进。并且不同的可见性关键字之间留一个空格。

    ```Ruby
    class SomeClass
      def public_method
        # ...
      end

      private
      def private_method
        # ...
      end
    end
    ```

* 使用 `def self.method` 来定义单例方法. 当代码重构时, 这将使得代码更加容易因为类名是不重复的.

    ```Ruby
    class TestClass
      # bad
      def TestClass.some_method
        # body omitted
      end

      # good
      def self.some_other_method
        # body ommited
      end

      # 也可以这样方便的定义多个单例方法。
      class << self
        def first_method
          # body omitted
        end

        def second_method_etc
          # body omitted
        end
      end
    end
    ```

    ```Ruby
    class SingletonTest
      def size
        25
      end
    end

    test1 = SingletonTest.new
    test2 = SingletonTest.new
    def test2.size
      10
    end
    test1.size # => 25
    test2.size # => 10
    ```
    本例中，test1 與 test2 屬於同一類別，但 test2 具有重新定義的 size 方法，因此兩者的行為會不一樣。只給予單一物件的方法稱為单例方法 (singleton method)。

## 异常

* 单个异常使用 `fail` 关键字仅仅当捕获一个异常并且反复抛出这个异常(因为这里你不是失败，而是准确的并且故意抛出一个异常)。

    ```Ruby
    begin
      fail 'Oops';
    rescue => error
      raise if error.message != 'Oops'
    end
    ```
* Never return from an `ensure` block. If you explicitly return from a
  method inside an `ensure` block, the return will take precedence over
  any exception being raised, and the method will return as if no
  exception had been raised at all. In effect, the exception will be
  silently thrown away.
  不要在 `ensure` 块中返回。如果你明确的从 `ensure` 块中的某个方法中返回，返回将会优于任何抛出的异常，并且尽管没有异常抛出也会返回。实际上异常将会静静的溜走。

    ```Ruby
    def foo
      begin
        fail
      ensure
        return 'very bad idea'
      end
    end
    ```

* Use *implicit begin blocks* when possible.使用**隐式 `begin` 代码块**如果可能。

    ```Ruby
    # bad
    def foo
      begin
        # main logic goes here
      rescue
        # failure handling goes here
      end
    end

    # good
    def foo
      # main logic goes here
    rescue
      # failure handling goes here
    end

* Mitigate the proliferation of `begin` blocks by using
  *contingency methods* (a term coined by Avdi Grimm).
  减少 `begin` 代码块的扩增通过一些 *contingency methods* 偶然性方法。

    ```Ruby
    # bad
    begin
      something_that_might_fail
    rescue IOError
      # handle IOError
    end

    begin
      something_else_that_might_fail
    rescue IOError
      # handle IOError
    end

    # good
    def with_io_error_handling
       yield
    rescue IOError
      # handle IOError
    end

    with_io_error_handling { something_that_might_fail }

    with_io_error_handling { something_else_that_might_fail }
    ```

* 不要抑制异常输出。

    ```Ruby
    # bad
    begin
      # an exception occurs here
    rescue SomeError
      # the rescue clause does absolutely nothing还没有补救代码
    end

    # bad
    do_something rescue nil
    ```


* 不要用异常来控制流。

    ```Ruby
    # bad
    begin
      n / d
    rescue ZeroDivisionError
      puts "Cannot divide by 0!"
    end

    # good
    if d.zero?
      puts "Cannot divide by 0!"
    else
      n / d
    end
    ```

* 应该总是避免拦截(最顶级的)Exception异常类。这里(ruby自身)将会捕获信号并且调用 `exit`，需要你使用 `kill -9` 杀掉进程。

    ```Ruby
    # bad
    begin
      # calls to exit and kill signals will be caught (except kill -9)
      exit
    rescue Exception
      puts "you didn't really want to exit, right?"
      # exception handling
    end

    # good
    begin
      # a blind rescue rescues from StandardError, not Exception as many
      # programmers assume.
    rescue => e
      # exception handling
    end

    # also good
    begin
      # an exception occurs here

    rescue StandardError => e
      # exception handling
    end

    ```

* 将更具体的异常放在拦截链的上方，否则他们将不会被捕获。

    ```Ruby
    # bad
    begin
      # some code
    rescue Exception => e
      # some handling
    rescue StandardError => e
      # some handling
    end

    # good
    begin
      # some code
    rescue StandardError => e
      # some handling
    rescue Exception => e
      # some handling
    end
    ```

* 使用 `ensure` 语句, 来确保总是执行一些特地的操作.

    ```Ruby
    f = File.open("testfile")
    begin
      # .. process
    rescue
      # .. handle error
    ensure
      f.close unless f.nil?
    end
    ```

* 除非必要, 尽可能使用Ruby标准库中异常类，而不是引入一个新的异常类。(而不是派生自己的异常类)

## 集合

* Prefer literal array and hash creation notation (unless you need to
pass parameters to their constructors, that is).不要想着使用文字而是使用创建符号来定义数组和哈希字典(除非你需要传递参数到它们的构造函数中)。

    ```Ruby
    # bad
    arr = Array.new
    hash = Hash.new

    # good
    arr = []
    hash = {}
    ```

* 总是使用 `%w` 的方式来定义字符串数组.(译者注: w表示英文单词word, 而且定义之间千万不能有逗号)

    ```Ruby
    # bad
    STATES = ['draft', 'open', 'closed']

    # good
    STATES = %w(draft open closed)
    ```

* 避免直接引用靠后的数组元素, 这样隐式的之前的元素都被赋值为nil.

    ```Ruby
    arr = []
    arr[100] = 1 # now you have an array with lots of nils
    ```

* 如果要确保元素唯一, 则使用 `Set` 代替 `Array` .`Set` 更适合于无顺序的, 并且元素唯一的集合, 集合具有类似于数组一致性操作以及哈希的快速查找.

* 尽可能使用符号代替字符串作为哈希键.

    ```Ruby
    # bad
    hash = { 'one' => 1, 'two' => 2, 'three' => 3 }

    # good
    hash = { one: 1, two: 2, three: 3 }
    ```

* 避免使用易变对象作为哈希键。
* 优先使用1.9的新哈希语法当你的哈希键是符号。

    ```Ruby
    # bad
    hash = { :one => 1, :two => 2, :three => 3 }

    # good
    hash = { one: 1, two: 2, three: 3 }
    ```

* 记住, 在Ruby1.9中, 哈希的表现不再是无序的. (译者注: Ruby1.9将会记住元素插入的序列)
* 当遍历一个集合的同时, 不要修改这个集合。

## 字符串

* 优先使用 `字符串插值` 来代替 `字符串串联`。

    ```Ruby
    # bad
    email_with_name = user.name + ' <' + user.email + '>'

    # good
    email_with_name = "#{user.name} <#{user.email}>"
    ```

* Consider padding string interpolation code with space. It more clearly sets the
  code apart from the string.考虑使用空格填充字符串插值。它更明确了除字符串的插值来源。

    ```Ruby
    "#{ user.last_name }, #{ user.first_name }"
    ```

* 当不需要使用 `字符串插值` 或某些特殊字符如 `\t`、 `\n`、`'`、等, 应该优先使用单引号.

    ```Ruby
    # bad
    name = "Bozhidar"

    # good
    name = 'Bozhidar'
    ```

* 当使用字符串插值替换 `实例变量` 时, 应该省略{}.

    ```Ruby
    class Person
      attr_reader :first_name, :last_name

      def initialize(first_name, last_name)
        @first_name = first_name
        @last_name = last_name
      end

      # bad
      def to_s
        "#{@first_name} #{@last_name}"
      end

      # good
      def to_s
        "#@first_name #@last_name"
      end
    end
    ```

* 操作较大的字符串时, 避免使用 `String#+` , 如果需要修改被操作字符串, 应该总是使用 `String#<<` 作为代替。就地并列字符串实例变体比 `String#+` 更快，它创建了多个字符串对象。

    ```Ruby
    # good and also fast
    html = ''
    html << '<h1>Page title</h1>'

    paragraphs.each do |paragraph|
      html << "<p>#{paragraph}</p>"
    end
    ```

## 正则表达式

* 如果只是需要中查找字符串的 `text`, 不要使用正则表达式：`string['text']`

* 针对简单的结构, 你可以直接使用string[/RE/]的方式来查询.

    ```Ruby
    match = string[/regexp/]             # get content of matched regexp
    first_group = string[/text(grp)/, 1] # get content of captured group
    string[/text (grp)/, 1] = 'replace'  # string => 'text replace'
    ```

* 当无需引用分组内容时, 应该使用(?:RE)代替(RE).

    ```Ruby
    /(first|second)/   # bad
    /(?:first|second)/ # good
    ```

* 避免使用 `$1-$9` 风格的分组引用, 而应该使用1.9新增的命名分组来代替.

    ```Ruby
    # bad
    /(regexp)/ =~ string
    ...
    process $1

    # good
    /(?<meaningful_var>regexp)/ =~ string
    ...
    process meaningful_var
    ```

* 字符类有以下几个特殊关键字值得注意: `^`, `-`, `\`, `]`, 所以, 不要转义 `.` 和 `[]` 中的括号, 他们是正常字符.

* 注意, `^` 和 `$` , 他们匹配行首和行尾, 而不是一个字符串的结尾, 如果你想匹配整个字符串, 用 `\A` 和 `\Z`。

    ```Ruby
    string = "some injection\nusername"
    string[/^username$/]   # matches
    string[/\Ausername\Z/] # don't match
    ```

* 使用 `x` 修饰符来匹配复杂的表达式, 这将使得RE更具可读性, 你可以添加一些有用的注释.
注意, 所有空格将被忽略.

    ```Ruby
    regexp = %r{
      start         # some text
      \s            # white space char
      (group)       # first group
      (?:alt1|alt2) # some alternation
      end
    }x
    ```

*  `sub`/`gsub`也支持哈希以及代码块形式语法, 可用于复杂情形下的替换操作.

## 百分号和字面值

* 多用 `%w`

    ```Ruby
    STATES = %w(draft open closed)
    ```

* 定义需要插值和嵌套双引号符号的单行字符串，使用 `%()` 的方式.而多行字符串, 尽量使用 heredocs 格式.

    ```Ruby
    # bad (不需要插值)
    %(<div class="text">Some text</div>)
    # should be '<div class="text">Some text</div>' # 应该这样写

    # bad (没有双引号)
    %(This is #{quality} style)
    # should be "This is #{quality} style" # 应该这样写

    # bad (multiple lines)
    %(<div>\n<span class="big">#{exclamation}</span>\n</div>)
    # should be a heredoc.

    # good (插值, 引号, 单行)
    %(<tr><td class="name">#{name}</td>)
    ```

    Heredoc is a robust way to create string in PHP with more lines but without using quotations.
    Heredoc 是 php 中不使用引号就可以创建多行字符串的一种强大的方式。

    line-oriented string literals (Here document)
There's a line-oriente form of the string literals that is usually called as `here document`. Following a `<<` you can specify a string or an identifier to terminate the string literal, and all lines following the current line up to the terminator are the value of the string. If the terminator is quoted, the type of quotes determines the type of the line-oriented string literal. Notice there must be **no space between `<<` and the terminator** .

    If the - placed before the delimiter, then all leading whitespcae characters (tabs or spaces) are stripped from input lines and the line containing delimiter. This allows here-documents within scripts to be indented in a natural fashion.

    ```Ruby
      print <<EOF
        The price is #{$Price}.
        EOF

      print <<"EOF";			# same as above
    The price is #{$Price}.
    EOF

      print <<`EOC`			# execute commands
    echo hi there
    echo lo there
    EOC

      print <<"foo", <<"bar"	# you can stack them
    I said foo.
    foo
    I said bar.
    bar

      myfunc(<<"THIS", 23, <<'THAT')
    Here's a line
    or two.
    THIS
    and here's another.
    THAT

      if need_define_foo
        eval <<-EOS			# delimiters can be indented
          def foo
            print "foo\n"
          end
        EOS
      end
    ```

* `%r` 的方式只适合于定义包含多个 `/` 符号的正则表达式。

    ```Ruby
    # bad
    %r(\s+)

    # still bad
    %r(^/(.*)$)
    # should be /^\/(.*)$/

    # good
    %r(^/blog/2011/(.*)$)
    ```

    ```Ruby
    irb(main):001:0> string="asdfas.64"
    => "asdfas.64"
    irb(main):002:0> string[/^\/(.*)$/]
    => nil
    irb(main):003:0> string="/asdfas.64"
    => "/asdfas.64"
    irb(main):004:0> string[/^\/(.*)$/]
    => "/asdfas.64"
    irb(main):007:0> string="/blog/2011/asdfas.64"
    => "/blog/2011/tmp/asdfas.64"
    irb(main):008:0> string[%r(^/blog/2011/(.*)$)]
    => "/blog/2011/tmp/asdfas.64"
    ```

* 避免使用`%q`，`%Q`， `%x`， `%s`,和 `%W`

* 优先使用()作为%类语法格式的分隔符.(译者注, 本人很喜欢 `%(...)`, 不过Programming Ruby中, 显然更喜欢使用%{}的方式)

## 元编程

* Avoid needless metaprogramming.避免无限循环的元编程。

* 在编写库时，不要乱动核心库。（不要画蛇添足）

* The block form of `class_eval` is preferable to the string-interpolated form. `class_eval` 代码块形式最好用于字符串插值形式。
  - when you use the string-interpolated form, always supply `__FILE__` and `__LINE__`, so that your backtraces make sense:当你使用字符串插值形式，总是提供 `__FILE__` 和 `__LINE__`，使得你的回溯有意义。

    ```ruby
    class_eval 'def use_relative_model_naming?; true; end', __FILE__, __LINE__
    ```

  - `define_method` 最好用 `class_eval{ def ... }`

* When using `class_eval` (or other `eval`) with string interpolation, add a comment block showing its appearance if interpolated (a practice I learned from the rails code):当使用 `class_eval` (或者其他的 `eval`)以及字符串插值，添加一个注释块使之在插入的时候现实(这是我从 rails 代码学来的实践)：

    ```ruby
    # from activesupport/lib/active_support/core_ext/string/output_safety.rb
    UNSAFE_STRING_METHODS.each do |unsafe_method|
      if 'String'.respond_to?(unsafe_method)
        class_eval <<-EOT, __FILE__, __LINE__ + 1
          def #{unsafe_method}(*args, &block)       # def capitalize(*args, &block)
            to_str.#{unsafe_method}(*args, &block)  #   to_str.capitalize(*args, &block)
          end                                       # end

          def #{unsafe_method}!(*args)              # def capitalize!(*args)
            @dirty = true                           #   @dirty = true
            super                                   #   super
          end                                       # end
        EOT
      end
    end
    ```

* avoid using `method_missing` for metaprogramming. Backtraces become messy; the behavior is not listed in `#methods`; misspelled method calls might silently work (`nukes.launch_state = false`). Consider using delegation, proxy, or `define_method` instead.  If you must, use `method_missing`,
* 避免在元编程中使用 `method_missing`，它使得回溯变得很麻烦，这个习惯不被列在 `#methods`，拼写错误的方法可能也在默默的工作 (`nukes.launch_state = false`)。考虑使用委托，代理或者是 `define_method` ，如果必须这样，使用 `method_missing` ，
  - be sure to [also define `respond_to_missing?`](http://blog.marc-andre.ca/2010/11/methodmissing-politely.html)
  - only catch methods with a well-defined prefix, such as `find_by_*` -- make your code as assertive as possible.
  - call `super` at the end of your statement
  - delegate to assertive, non-magical methods:

    ```ruby
    # bad
    def method_missing?(meth, *args, &block)
      if /^find_by_(?<prop>.*)/ =~ meth
        # ... lots of code to do a find_by
      else
        super
      end
    end

    # good
    def method_missing?(meth, *args, &block)
      if /^find_by_(?<prop>.*)/ =~ meth
        find_by(prop, *args, &block)
      else
        super
      end
    end

    # best of all, though, would to define_method as each findable attribute is declared
    ```

## 杂项

* 总是打开Ruby -w开关。
* 通常情况下, 尽量避免使用哈希作为方法的 `optional` 参数. (此时应该考虑这个方法是不是功能太多?)
* 避免一个方法内容超过10行代码, 理想情况下, 大多数方法内容应该少于5行.(不算空行)
* 尽量避免方法的参数超过三或四个.
* 有时候, 必须用到全局方法, 应该增加这些方法到 Kernel 模块，并设置他们可见性关键字为 `private`。
* 尽可能使用类实例变量代替全局变量. (译者注:是类实例变量, 而不是类的实例变量. 汗~~)

    ```Ruby
    #bad
    $foo_bar = 1

    #good
    class Foo
      class << self
        attr_accessor :bar
      end
    end

    Foo.bar = 1
    ```

* 能够用 `alias_method` 就不要用 `alias`。
* 使用 `OptionParser` 来解析复杂的命令行选项， 较简单的命令行， `-s` 参数即可。
* 按照功能来编写方法, 当方法名有意义时, 应该避免方法功能被随意的改变。
* 避免不需要的元编程。
* 除非必要, 避免更改已经定义的方法的参数。
* 避免超过三级的代码块嵌套。
* 应该持续性的遵守以上指导方针。
* 多使用（生活）常识。

# Contributing

Nothing written in this guide is set in stone. It's my desire to work
together with everyone interested in Ruby coding style, so that we could
ultimately create a resource that will be beneficial to the entire Ruby
community.

Feel free to open tickets or send pull requests with improvements. Thanks in
advance for your help!

# Spread the Word

A community-driven style guide is of little use to a community that
doesn't know about its existence. Tweet about the guide, share it with
your friends and colleagues. Every comment, suggestion or opinion we
get makes the guide just a little bit better. And we want to have the
best possible guide, don't we?
