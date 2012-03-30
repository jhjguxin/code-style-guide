# 序

> 风格可以用来区分从好到卓越。<br />
> -- Bozhidar Batsov

整个 `guide` 是为了展示一系列的 Rails 3 开发的最佳实践和风格惯例。这是一份与由现存社群所驱动的与 [Ruby coding style guide](https://github.com/bbatsov/ruby-style-guide) 互补的指南。

教程中 [Testing Rails applications](#testing) 章节放在 [Developing Rails applications](#developing) 是因为在我心中，我相信 [Behaviour-Driven Development](http://en.wikipedia.org/wiki/Behavior_Driven_Development) (BDD行为驱动开发) 是开发软件的最好的方法。

Rails 是一个坚持己见的框架，而这也是一份坚持己见的指南。在我的心里，我坚信 [RSpec](https://www.relishapp.com/rspec) 优于 Test::Unit，[Sass](http://sass-lang.com/) 优于 CSS 以及
[Haml](http://haml-lang.com/)，([Slim](http://slim-lang.com/)) 优于 Erb. 所以不要期望在这里找到 Test::Unit, CSS 及 Erb 的忠告。

这里的一些忠告仅仅适用于 Rails 3.1+ 版本。

你可以使用 [Transmuter](https://github.com/TechnoGate/transmuter) 来生成本教程的 PDF 和 HTML 副本。

# 开发 Rails 应用程序

## Configuration 配置

* 自定义的初始化代码放置在 `config/initializers`。`initializers` 中的代码会在程序启动的时候被执行。 
* 每一个 gem 相关的初始化代码应当使用同样的名称，放在不同的文件里，如： `carrierwave.rb`, `active_admin.rb`, 等等。
* 调整配置开发、测试及生产环境相应在 `config/environments/` 下对应的文件。
  * 标记额外的 assets 进行预编译(如果存在)：

    ```Ruby
    # config/enviromments/production.rb
    # Precompile additional assets (application.js, application.css, and all not-JS/CSS are already added)
    config.assets.precomplie += %w( rails_admin/rails_admin.css rails_admin/rails_admin.js )
    ```
* 创立一个额外的类似于生产环境相似的 `staging` 环境。

## Routing 路由

* 当你需要添加更多的 actions 到一个 `RESRful` resource (你是真的需要码？)使用 `member` 和 `collection` 路由。

    ```Ruby
    # bad
    get 'subscriptions/:id/unsubscribe'
    resources :subscriptions

    # good
    resources :subscriptions do
      get 'unsubscribe', :on => :member
    end

    # bad
    get 'photos/search'
    resources :photos

    # good
    resources :photos do
      get 'search', :on => :collection
    end
    ```

* 如果你需要定义多个 `member/collection` 路由使用块语句作为替代。

    ```Ruby
    resources :subscriptions do
      member do
        get 'unsubscribe'
        # more routes
      end
    end

    resources :photos do
      collection do
        get 'search'
        # more routes
      end
    end
    ```

* 使用嵌套的路由来解释 `ActiveRecord models` 之间的关系更好。

    ```Ruby
    class Post < ActiveRecord::Base
      has_many :comments
    end

    class Comments < ActiveRecord::Base
      belongs_to :post
    end

    # routes.rb
    resources :posts do
      resources :comments
    end
    ```

* 使用名称空间路由来分组关联的 actions。

    ```Ruby
    namespace :admin do
      # Directs /admin/products/* to Admin:ProductsController
      # (app/controllers/admin/products_controller.rb)
      resources :products
    end
    ```

* 绝不使用以前的疯狂控制器路由。这个 reoute 会使得所有的 controller 的每个Actions都可以通过 GET 请求访问。

    ```Ruby
    # very bad
    match ':controller(/:action(/:id(.:format)))'
    ```

## Controllers 控制器

* 保持 controllers 苗条 - 他们应该回收从 view layer 的数据并且不应该包含任何业务逻辑（所有的业务逻辑应该自然的置于相应的 model 中）。[rails中的业务处理Active Record Transactions](http://jhjguxin.sinaapp.com/?p=341)
* 每个控制器的 action 应该（理想的）包含且仅包含一个方法（除了 find 或者 new）。
* 不要在一个 controller 或者 view 中共享超过两个实例变量。

## Models 模型

* 自由的引用 non-ActiveRecord 类。
* 模型需根据其意义命名（简短）且不带缩写的名字。 
* 如果你需要 model 对象支持 ActiveRecord 行为比如 验证则使用 [ActiveAttr](https://github.com/cgriego/active_attr) gem。

    ```Ruby
    class Message
      include ActiveAtrr::Model

      attribute :name
      attribute :email
      attribute :content
      attribute :priority

      attr_accessible :name, :email, :content

      validates_presence_of :name
      validates_format_of :email, with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i]
      validates_length_of :content, :maximum => 500
    end
    ```

* 更完整的示例，参考 [RailsCast on the subject](http://railscasts.com/episodes/326-activeattr)。

#### Regular Expression Options

<table>
  <thead>
    <tr>
        <th>RegexOptions member</th><th>Inline character</th><th>Effect</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>None</td><td>Not available</td><td>Use default behavior. For more information, see Default Options.</td>
    </tr>
    <tr>
        <td>IgnoreCase</td><td>i</td><td>Use case-insensitive matching. For more information, see Case-Insensitive Matching.</td>
    </tr>
    <tr>
        <td>Multiline</td><td>m</td><td>Use multiline mode, where ^ and $ match the beginning and end of each line (instead of the beginning and end of the input string). For more information, see Multiline Mode.</td>
    </tr>
    <tr>
        <td>Singleline</td><td>s</td><td>Use single-line mode, where the period (.) matches every character (instead of every character except \n). For more information, see Singleline Mode.</td>
    </tr>
    <tr>
        <td>ExplicitCapture</td><td>n</td><td>Do not capture unnamed groups. The only valid captures are explicitly named or numbered groups of the form (?<name> subexpression). For more information, see Explicit Captures Only.</td>
    </tr>
    <tr>
        <td>Compiled</td><td>Not available</td><td>Compile the regular expression to an assembly. For more information, see Compiled Regular Expressions.</td>
    </tr>
    <tr>
        <td>IgnorePatternWhitespace</td><td>x</td><td>Exclude unescaped white space from the pattern, and enable comments after a number sign (#). For more information, see Ignore Whitespace.</td>
    </tr>
    <tr>
        <td>RightToLeft</td><td>Not available</td><td>Change the search direction. Search moves from right to left instead of from left to right. For more information, see Right-to-Left Mode.</td>
    </tr>
    <tr>
        <td>ECMAScript</td><td>Not available</td><td>Enable ECMAScript-compliant behavior for the expression. For more information, see ECMAScript Matching Behavior.</td>
    </tr>
    <tr>
        <td>CultureInvariant</td><td>Not available</td><td>Ignore cultural differences in language. For more information, see Comparison Using the Invariant Culture.</td>
    </tr>
  </tbody>
</table>

### ActiveRecord

* 避免修改 ActiveRecord 默认的(table names, primary key, etc)，除非你有很好的理由（像是不受你控制的数据库）(like a database that's not under your control)。
* 把 macro-style 的方法放在类定义的前面（has_many, validates, 等等）。
* 优先使用 `has_many :through` 代替 `has_and_belongs_to_many`。使用 `has_many :through` 可以在 `join` model 的时候能添加额外的属性和验证。

    ```Ruby
    # using has_and_belongs_to_many
    class User < ActiveRecord::Base
      has_and_belongs_to_many :groups
    end

    class Group < ActiveRecord::Base
      has_and_belongs_to_many :users
    end

    # prefered way - using has_many :through
    class User < ActiveRecord::Base
      has_many :memberships
      has_many :groups, through: :memberships
    end

    class Membership < ActiveRecord::Base
      belongs_to :user
      belongs_to :group
    end

    class Group < ActiveRecord::Base
      has_many :memberships
      has_many :users, through: :memberships
    end
    ```

* 尽量使用新的 ["sexy" validations](http://thelucid.com/2010/01/08/sexy-validation-in-edge-rails-rails-3/)。
* 当一个验证使用超过一次或验证是某个正则表达映射时，创建一个（单独的） `validator` 文件

    ```Ruby
    # bad
    class Person
      validates :email, format: { with: /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }
    end

    # good
    class EmailValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        record.errors[attribute] << (options[:message] || 'is not a valid email') unless value =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
      end
    end

    class Person
      validates :email, email: true
    end
    ```
    #### about `~=`

    ```Ruby
    "cat o' 9 tails" =~ /\d/   #=> 7
    "cat o' 9 tails" =~ 9      #=> nil
    /at/ =~ "input data"   #=> 7
    /ax/ =~ "input data"   #=> nil
    ```

* 所有自定义的 validators 应放在一个共享的 gem 。
* 多用 scopes。
* 当一个由 `lambda` 及参数定义的作用域变得过于复杂时，更好的方式是建一个作为同样用途的类方法，并返回 `ActiveRecord::Relation` 对象。
* 注意 `update_attribute` 方法的行为。它不运行模型验证（不同于 `update_attributes` ）并且可能把模型状态给搞砸。
* 使用用户友好的网址。在网址显示具描述性的模型属性，而不只是 id 。
有不止一种方法可以达成：
  * 覆写模型的 `to_param` 方法。这是 Rails 用来给对象建构网址的方法。缺省的实作会以字串形式返回该 id 的记录。它可被另一个 human-readable 的属性覆写。

        ```Ruby
        class Person
          def to_param
            "#{id} #{name}".parameterize
          end
        end
        ```

        为了要转换成对网址友好 (URL-friendly)的数值，字串应当调用 `parameterize`。 对象的 `id` 要放在开头，以便给 ActiveRecord 的 `find` 方法查找。

* 使用此 `friendly_id` gem。它允许藉由模型的某些具描述性属性，而不是用 `id` 来创建 human-readable 的网址。

        ```Ruby
        class Person
          extend FriendlyId
          friendly_id :name, use: :slugged
        end
        ```

        查看  [gem documentation](https://github.com/norman/friendly_id) 文档 获得更多关于使用的信息。







