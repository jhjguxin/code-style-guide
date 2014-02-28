# 序

> 榜样很重要。<br/>
> -- Officer Alex J. Murphy / RoboCop

整个 `guide` 是为了呈现一系列的适用于 Rails 3 & Rails 4 开发的最佳实践和风格惯例。这是一份与由现存社群所驱动的 [Ruby coding style guide](https://github.com/bbatsov/ruby-style-guide) 互补的指南。

教程中 [Testing Rails applications](#testing-rails-applications) 章节放在 [Developing Rails applications](#developing-rails-applications) 后面是因为在我心中，我相信 [Behaviour-Driven Development](http://en.wikipedia.org/wiki/Behavior_Driven_Development) (BDD行为驱动开发) 是开发软件的最好的方法。在心中留住这个想法。

Rails 是一个坚持己见的框架，而这也是一份坚持己见的指南。在我的心里，我坚信 [RSpec](https://www.relishapp.com/rspec) 优于 Test::Unit，[Sass](http://sass-lang.com/) 优于 CSS 以及
[Haml](http://haml-lang.com/)，([Slim](http://slim-lang.com/)) 优于 Erb。 所以不要期望在这里找到 Test::Unit, CSS 及 Erb 的忠告。

这里的一些忠告仅仅适用于 Rails 3.1+ 版本。

你可以使用 [Transmuter](https://github.com/TechnoGate/transmuter) 来生成本教程的 PDF 和 HTML 副本。

改指南有下列语言的译文：

* [Chinese Simplified](https://github.com/JuanitoFatas/rails-style-guide/blob/master/README-zhCN.md)
* [Chinese Traditional](https://github.com/JuanitoFatas/rails-style-guide/blob/master/README-zhTW.md)

# Table of Contents

* [开发 Rails 应用程序](#开发-rails-应用程序)
    * [Configuration 配置](#configuration-配置)
    * [Routing 路由](#routing-路由)
    * [Controllers 控制器](#controllers-控制器)
    * [Models 模型](#models-模型)
    * [ActiveRecord](#activerecord)
    * [Migrations 迁移](#migrations)
    * [Views](#views)
    * [Internationalization 国际化](#internationalization-国际化)
    * [Assets](#assets)
    * [Mailers](#mailers)
    * [Bundler](#bundler)
    * [Priceless Gems](#priceless-gems-无价的-gems)
    * [Flawed Gems 缺陷的 Gems](#flawed-gems-缺陷的-gems)
    * [Managing processes](#managing-processes)
* [Testing Rails applications 测试 Rails 应用程序](#testing-rails-applications-测试-rails-应用程序)
    * [Cucumber](#cucumber)
    * [RSpec](#rspec)

# 开发 Rails 应用程序

## Configuration 配置

* 自定义的初始化代码放置在 `config/initializers`。`initializers` 中的代码会在程序启动的时候被执行。
* 每一个 gem 相关的初始化代码应当使用同样的名称，放在不同的文件里，如： `carrierwave.rb`, `active_admin.rb`, 等等。
* 调整配置开发、测试及生产环境相应（在 `config/environments/` 下对应的文件）。
  * 标记额外的 assets 进行预编译(如果存在)：

    ```Ruby
    # config/enviromments/production.rb
    # Precompile additional assets (application.js, application.css, and all not-JS/CSS are already added)
    config.assets.precomplie += %w( rails_admin/rails_admin.css rails_admin/rails_admin.js )
    ```

* 将应用于所有环境的配置放在 `config/application.rb` 文件中。
* 创立一个额外的类似于生产环境相似的 `staging` 环境。

## Routing 路由

* 当你需要添加更多的 actions 到一个 `RESRful` resource（你是真的需要码？）使用 `member` 和 `collection` 路由。

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

* 如果你需要定义多个 `member/collection` 路由使用另一种块语句。

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

* 绝不使用以前的疯狂控制器路由。这个 route 会使得所有的 controller 的每个 actions 都可以通过 GET 请求访问。

    ```Ruby
    # very bad
    match ':controller(/:action(/:id(.:format)))'
    ```

* 不要使用 `match` 定义任何 routes。它将会在 rails 4 被移除。

## Controllers 控制器

* 保持 controllers 苗条 - 他们应该回收从 view layer 的数据并且不应该包含任何业务逻辑（所有的业务逻辑应该自然的置于相应的 model 中）。[rails中的业务处理Active Record Transactions](http://jhjguxin.sinaapp.com/?p=341)
* 每个控制器的 action 应该（理想的）包含且仅包含一个方法（除了 find 或者 new）。
* 不要在一个 controller 或者一个 view 中共享超过两个实例变量。

## Models 模型

* 自由的引入 non-ActiveRecord 模型类。
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
        <td>IgnoreCase</td><td>`i`</td><td>Use case-insensitive matching. For more information, see Case-Insensitive Matching.</td>
    </tr>
    <tr>
        <td>Multiline</td><td>`m`</td><td>Use multiline mode, where ^ and $ match the beginning and end of each line (instead of the beginning and end of the input string). For more information, see Multiline Mode.</td>
    </tr>
    <tr>
        <td>Singleline</td><td>`s`</td><td>Use single-line mode, where the period (.) matches every character (instead of every character except \n). For more information, see Singleline Mode.</td>
    </tr>
    <tr>
        <td>ExplicitCapture</td><td>`n`</td><td>Do not capture unnamed groups. The only valid captures are explicitly named or numbered groups of the form (?<name> subexpression). For more information, see Explicit Captures Only.</td>
    </tr>
    <tr>
        <td>Compiled</td><td>Not available</td><td>Compile the regular expression to an assembly. For more information, see Compiled Regular Expressions.</td>
    </tr>
    <tr>
        <td>IgnorePatternWhitespace</td><td>`x`</td><td>Exclude unescaped white space from the pattern, and enable comments after a number sign (#). For more information, see Ignore Whitespace.</td>
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

* 避免修改 ActiveRecord 默认的(table names, primary key, etc)，除非你有很好的理由（比如数据库不是受你控制的）(like a database that's not under your control)。
* 把 macro-style（宏风格）的方法放在类定义的前面（`has_many`, `validates`, 等等）。

    ```Ruby
    class User < ActiveRecord::Base
      # keep the default scope first (if any)
      default_scope { where(active: true) }

      # constants come up next
      GENDERS = %w(male female)

      # afterwards we put attr related macros
      attr_accessor :formatted_date_of_birth

      attr_accessible :login, :first_name, :last_name, :email, :password

      # followed by association macros
      belongs_to :country

      has_many :authentications, dependent: :destroy

      # and validation macros
      validates :email, presence: true
      validates :username, presence: true
      validates :username, uniqueness: { case_sensitive: false }
      validates :username, format: { with: /\A[A-Za-z][A-Za-z0-9._-]{2,19}\z/ }
      validates :password, format: { with: /\A\S{8,128}\z/, allow_nil: true}

      # next we have callbacks
      before_save :cook
      before_save :update_username_lower

      # other macros (like devise's) should be placed after the callbacks

      ...
    end
    ```


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
      validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
    end

    # good
    class EmailValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        record.errors[attribute] << (options[:message] || 'is not a valid email') unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
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

* 所有自定义的 validators 应放在 `app/validators` 中。
* 考虑提取自定义的 `validator` 到一个共享的 gem 如果你正在维护一系列的
  相关的应用或者 validators
* 自由的使用有意义的 scopes。

    ```Ruby
    class User < ActiveRecord::Base
      scope :active, -> { where(active: true) }
      scope :inactive, -> { where(active: false) }

      scope :with_orders, -> { joins(:orders).select('distinct(users.id)') }
    end
    ```

* Wrap named scopes in `lambdas` to initialize them lazily.包裹命名的 scopes 到 `lambdas` 可以很偷懒的初始化它们（在 Rails 3 只是一个偏方，但是在 Rails 4 是强制性的）。

    ```Ruby
    # bad
    class User < ActiveRecord::Base
      scope :active, where(active: true)
      scope :inactive, where(active: false)

      scope :with_orders, joins(:orders).select('distinct(users.id)')
    end

    # good
    class User < ActiveRecord::Base
      scope :active, -> { where(active: true) }
      scope :inactive, -> { where(active: false) }

      scope :with_orders, -> { joins(:orders).select('distinct(users.id)') }
    end
    ```

* 当一个由 `lambda` 及参数定义的作用域变得过于复杂时，更好的方式是构建一个作为同样用途的类方法，并返回 `ActiveRecord::Relation` 对象。另一种有争论的做法是，你可以像下面这样定义相当简单的 scopes。


    ```Ruby
    class User < ActiveRecord::Base
      def self.with_orders
        joins(:orders).select('distinct(users.id)')
      end
    end
    ```

* 注意 `update_attribute` 方法的行为。它不运行模型验证（不同于 `update_attributes` ）并且可能把模型状态给搞砸。这个方法最终在 Rails 3.2.7 （开始被）弃用并且在 Rails 4 中不会存在。
* 使用用户友好的网址。在网址显示具描述性的模型属性，而不只是 id 。
有不止一种方法可以达成：
  * 覆写模型的 `to_param` 方法。这是 Rails 用来给对象建构网址的方法。
  缺省的实作会以返回该记录 id 的字串形式。它可被另一个 human-readable 的属性覆写。

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

*  使用 `find_each` 来一个 AR 集合的所有对象。因为它将会尝试通过循环来自数据库
   的一个集合（例如，使用 `all` 方法）来一次性实例化所有的对象这是很低效的。
   在这样的场景中，块处理方法允许你以块的方式来处理记录，因此会大大的减少内存开销。


    ```Ruby
    # bad
    Person.all.each do |person|
      person.do_awesome_stuff
    end

    Person.where("age > 21").each do |person|
      person.party_all_night!
    end

    # good
    Person.all.find_each do |person|
      person.do_awesome_stuff
    end

    Person.where("age > 21").find_each do |person|
      person.party_all_night!
    end
    ```

## Migrations

* 将 `schema.rb`（或者 `structure.sql`）置于版本控制中。
* 使用 `rake db:scheme:load` 取代 `rake db:migrate` 来初始化空的数据库。
* 使用 `rake db:test:prepare` 来更新测试数据库结构。
* 避免在迁移本身设置缺省数据。以应用程序层取代之。

    ```Ruby
    def amount
      self[:amount] or 0
    end
    ```

    While enforcing table defaults only in Rails is suggested by many
    Rails developers, it's an extremely brittle approach that
    leaves your data vulnerable to many application bugs.  And you'll
    have to consider the fact that most non-trivial apps share a
    database with other applications, so imposing data integrity from
    the Rails app is impossible.
    执行表默认值仅仅在 Rails 中被很多 Rails 开发人员建议，然而它是一种非常
    脆弱的方式会使你的数据很容易导致很多应用程序 bugs。并且你将不得不考虑这个事实就是
    大多数应用会和其它应用程序共享数据库，因此从 Rails 应用提升数据的完整性是不可能的。

* 强制执行外键结构。但是 ActiveRecord 并没有自然的支持它，这里有些很棒的第三方 gems 如同 [schema_plus](https://github.com/lomba/schema_plus) 和 [foreigner](https://github.com/matthuhiggins/foreigner).

* 当编写结构性的迁移时（加入表或字段位），使用 Rails 3.1 的新方式来迁移， 使用 `change` 方法取代 `up` 与 `down` 方法。

    ```Ruby
    # the old way
    class AddNameToPeople < ActiveRecord::Migration
      def up
        add_column :people, :name, :string
      end

      def down
        remove_column :people, :name
      end
    end

    # the new prefered way
    class AddNameToPeople < ActiveRecord::Migration
      def change
        add_column :people, :name, :string
      end
    end
    ```

* Don't use model classes in migrations. The model classes are
constantly evolving and at some point in the future migrations that
used to work might stop, because of changes in the models used.
* 不要在 model 类中使用迁移。 model 类是经常变更的并且在迁移工作的某个点可能会停止，
  因为 model 中的变更被使用。

## Views

* 不要直接从视图调用 model 层。
* 不要在 view 中构造复杂的格式，把它们输出到 view `helper` 或是 model 的一个方法。
* 使用 `partial` 模版和布局来减少重复的代码。

## Internationalization 国际化

* view 、model 与 controller 里不应设置字符串或者其他 区域(local) 相关设置。这些文字应搬到在 `config/locales` 目录下的 local 文件里。
* 当 ActiveRecord model 的标签需要被翻译时，使用 `activerecord` 作用域:

    ```
    en:
      activerecord:
        models:
          user: Member
        attributes:
          user:
            name: "Full name"
    ````

    然后 `User.model_name.human` 将会返回 "Member" 以及 `User.human_attribute_name("name")` 将会返回 "Full name"。这些属性的翻译会被视图作为标签。

* 把在视图使用的文字和 ActiveRecord 的属性的翻译应该分开。将 models 的 locale 文件放在一个名叫 `models` 的文件夹中，并且将在视图中使用的文字放在一个名叫 `views` 的文件夹中。
  * 当使用了额外的目录来组织 locale 文件之时，为了要载入这些目录，要在 `application.rb` 文件里描述这些目录。
        ```Ruby
        # config/application.rb
        config.i18n.load_path += Dir[Rails.root.join('config'), 'locales', '**', '*.{rb.yml}']
        ```

* 把共享的 localization 选项，像是日期及货币格式，放在 `locales` 的根目录下。
* 使用缩写形式的 I18n 方法： `I18n.t` 代替 `I18n.translate` 以及 'I18n.l' 代替 'I18n.localize'。

    ```Ruby
    translate # Lookup text translations
    localize # Localize Date and Time objects to local formats
    ```

* 使用 "lazy" 查询视图中使用的文字。假设我们有以下结构：
    ```
    en:
      users:
        show:
          title: "User details page"
    ```

    `users.show.title` 这样的(locals)值能被 `app/views/users/show.html.haml` 以如下方式查询：

    ```Ruby
    = t '.title'
    ```

* 在控制器以及模型中使用点分割的方式替代 `:scope` 选项。点分割形式的调用更加易读和追踪层级。

    ```Ruby
    # use this call
    I18n.t 'activerecord.errors.messages.record_invalid'

    # instead of this
    I18n.t :record_invalid, :scope => [:activerecord, :errors, :messages]
    ```

* 关于 Rails i18n 更详细的信息可以在这里找到 [Rails Guides](http://guides.rubyonrails.org/i18n.html)。

## Assets

利用 [assets pipeline](http://guides.rubyonrails.org/asset_pipeline.html) 来合理的组织应用的结构。

The asset pipeline provides a framework to concatenate and minify or compress JavaScript and CSS assets. It also adds the ability to write these assets in other languages such as CoffeeScript, Sass and ERB.

* 保留 `app/assets` 给自定的样式表，Javascripts 或图片。
* 把自己开发，但不适合于整个应用的函式库，放在 `lib/assets/`。
* `asset pipeline` 提供了一个框架来组合精简或者编译 JavaScrip 和 CSS assets。它同样也使得用其他语言如 CoffeScript， Sass 和 ERB 编写 assets 成为可能。
* 第三方代码比如 [jQuery](http://jquery.com/) 或者 [bootstrap](http://twitter.github.com/bootstrap/) 应该被放在 `vendor/assets` 中。
* 如果可能，使用 gem 化的 assets 版本。(如： [jquery-rails](https://github.com/rails/jquery-rails))，[jquery-ui-rails](https://github.com/joliss/jquery-ui-rails)，[bootstrap-sass](https://github.com/thomas-mcdonald/bootstrap-sass)，[zurb-foundation](https://github.com/zurb/foundation))。


## Mailers

* 把 mailers 命名为 `SomethingMailer`。 没有 `Mailer` 后缀，不能立即显现它是一个 mailer，以及哪个视图与它有关。
* 提供 HTML 以及纯文本（给）视图模板。
* 在你的开发环境中启用信件发送失败 errors railsed。这些错误缺省是被停用的。

    ```Ruby
    # config/environments/development.rb

    config.action_mailer.raise_delivery_errors = true
    ```

* 在开发模式环境中使用 `smtp.gmail.com` （除非你有了本地的 SMTP 服务器，当然可以使用自己的服务器地址）。

    ```Ruby
    # config/environments/development.rb

    config.action_mailer.smtp_settings = {
      address: 'smtp.gmail.com',
      # more settings
    }
    ```

* 在开发环境中使用一个像 [Mailcatcher](https://github.com/sj26/mailcatcher) 这样的本地的 SMTP 服务器。

    ```Ruby
    # config/environments/development.rb

    config.action_mailer.smtp_settings = {
      address: 'localhost',
      port: 1025,
      # more settings
    }
    ```

* 提供一个缺省的主机名。

    ```Ruby
    # config/environments/development.rb
    config.action_mailer.default_url_options = {host: "#{local_ip}:3000"}


    # config/environments/production.rb
    config.action_mailer.default_url_options = {host: 'your_site.com'}

    # in your mailer class
    default_url_options[:host] = 'your_site.com'
    ```

* 如果你需要在 email 中使用一个到站点的连接，通常使用 `_url` 而不是 `_path` 方法。`_url` 方法包含主机名但是 `_path` 方法却不包含。

    ```Ruby
    # wrong
    You can always find more info about this course
    = link_to 'here', url_for(course_path(@course))

    # right
    You can always find more info about this course
    = link_to 'here', url_for(course_url(@course))
    ```

* 正确地显示寄与收件人地址的格式。使用下列格式：

    ```Ruby
    # in your mailer class
    default from: 'Your Name <info@your_site.com>'
    ```

* 确保在你测试环境中 e-mail 邮寄方法被设置为 `test`：

    ```Ruby
    # config/environments/test.rb

    config.action_mailer.delivery_method = :test
    ```

* 在开发模式和产品模式环境中邮寄方法应该是 `smtp`：

    ```Ruby
    # config/environments/development.rb, config/environments/production.rb

    config.action_mailer.deliver_method = :smtp
    ```

* 当发送 HTML email 时，所有样式应为行内样式，这是由于某些用户有关于外部样式的问题。某种程度上这使得更难管理及造成代码重用。有两个相似的 gem 可以转换样式，以及将它们放在对应的 html 标签里： [premailer-rails3](https://github.com/fphilipe/premailer-rails3) 和 [roadie](https://github.com/Mange/roadie)。

* 应避免页面产生响应时寄送 email。若多个 email 寄送时，会造成了页面载入延迟，以及请求可能超时。使用 [sidekiq](https://github.com/mperham/sidekiq) gem 的帮助来克服在背景处理寄送 email 的问题。

## Bundler

* 将只在开发模式或者测试模式中使用的 gems 放入 Gemfile 内相应的 group 中。
* 在你的项目中只使用公认的 gem。 如果你考虑引入某些鲜为人知的 gem，你应该先仔细复查一下它的源代码。
* 关于多个开发者使用不同操作系统的项目，操作系统相关的 gem 缺省会产生一个经常变动的 Gemfile.lock 。 在 Gemfile 文件里，所有与 OS X 相关的 gem 放在 `darwin` 群组，而所有 Linux 相关的 gem 放在 `linux` 群组：

    ```Ruby
    # Gemfile
    group :darwin do
      gem 'rb-fsevent'
      gem 'growl'
    end

    group :linux do
      gem 'rb-inotify'
    end
    ```

    要在对的环境获得合适的 gem ， 添加以下代码至 `config/application.rb`：

    ```Ruby
    platform = RUBY_PLATFORM.math(/(linux/darwin)/)[0].to_sym
    Bundler.require(platform)
    ```

* 不要把 Gemfile.lock 文件从版本控制中移除。这不是随机产生的文件 - 它确保你所有的组员执行 `bundle install` 时，能够获得相同版本的 gem 。

## Priceless Gems 无价的 Gems

一个最重要的编程理念是 "不要重造轮子！" 。若你遇到一个特定问题，在你开始前，总是应该去看一下是否有存在的解决方案。下面是一些在很多 Rails 项目中 "无价的" gem 列表（全部兼容 Rails 3.1）：

* [active_admin](https://github.com/gregbell/active_admin) - 通过ActiveAdmin 你创建你的 Rails 应用
  程序的 admin 界面好像玩一样。你可以得到一个漂亮的仪表盘，CRUD UI 以及更多。非常灵活以及定制性（很强）。
* [better_errors](https://github.com/charliesome/better_errors) - - Better Errors 用更好更有效的
  错误页面，取代了 Rails 标准的错误页面。不仅可用在 Rails，任何将 Rack 当作中间件的 app 都可使用。
* [bullet](https://github.com/flyerhzm/bullet) - Bullet 就是为了帮助提升应用的效能（通过减少查询）
  而打造的 gem。会在你开发应用时，替你注意你的查询，并在需要 eager loading (N+1 查询)时、或是你在
  不必要的情况使用 eager loading 时，或是在应该要使用 counter cache 时，都会提醒你。
* [cancan](https://github.com/ryanb/cancan) - CanCan 是一个权限管理的 gem， 让你可以管制用户
  对资源的访问。所有的授权都定义在一个档案里（ability.rb），并提供许多方便的方法，让你检查及确保
  整个应用内权限是否是可用的。
* [capybara](https://github.com/jnicklas/capybara) - Capybara 旨在简化整合测试 Rack 应用的过程，
  像是 Rails、Sinatra 或 Merb。Capybara 模拟了真实用户使用 web 应用的互动。 它与你测试在运行的驱动
  无关，并原生搭载 Rack::Test 及 Selenium 支持。透过外部 gem 支持 HtmlUnit、WebKit 及 env.js 。
  与 RSpec & Cucumber 一起使用工作良好。
* [carrierwave](https://github.com/jnicklas/carrierwave) - Rails 终极文件上传解决方案。支持
  上传档案（及很多其它的酷玩意儿的）的本地储存与云储存。与 ImageMagick 的图片后期处理整合得非常好。
* [compass-rails](https://github.com/compass/compass-rails)  一个优秀的 gem，添加了某些 css 框架的支持。包括了 sass mixin 的 collection（集合），让你减少 css 文件的代码并帮你解决浏览器兼容问题。
* [cucumber-rails](https://github.com/cucumber/cucumber-rails) - Cucumber 是一个由 Ruby 所写，开发功能测试的顶级工具。 cucumber-rails 提供了 Cucumber 的 Rails 整合。
* [devise](https://github.com/plataformatec/devise) - Devise 是 Rails 应用的一个完整解决方案。多数情况偏好使用 devise 来开始你的自定义验证方案。
* [fabrication](http://fabricationgem.org/) - 一个很好的假数据产生器。
* [factory_girl](https://github.com/thoughtbot/factory_girl) - 另一个 fabrication 的选择。一个成熟的假数据产生器。 Fabrication 的精神领袖先驱。
* [ffaker](https://github.com/EmmanuelOga/ffaker) - 实用的 gem 来产生仿造的数据（名字、地址，等等）。
* [feedzirra](https://github.com/pauldix/feedzirra) 快速且流畅的 RSS/Atom feed 生成器。
* [friendly_id](https://github.com/norman/friendly_id) - 通过使用某些具描述性的模型属性，而不是使用 id，允许你创建 human-readable 的网址。
* [globalize](https://github.com/globalize/globalize) - ActiveRecord model/data 业务
  的 Rails I18n 实际的标准库。Globalize 适用于 Rails 并且目标是 ActiveRecord 4.x 版本，它兼容并且内
  置于 Ruby on Rails 新的 I18n API并且添加 model 业务到 ActiveRecord。对于 ActiveRecord 3.x 用户，
  点击 [3-0-stable branch](https://github.com/globalize/globalize/tree/3-0-stable)。
* [guard](https://github.com/guard/guard) - 极佳的 gem 监控文件变化及任务的调用。搭载了很多实用的扩充。远优于 autotest 与 watchr。
* [haml-rails](https://github.com/indirect/haml-rails) - haml-rails 提供了 Haml 的 Rails 整合。
* [haml](http://haml-lang.com) Haml 是一个简洁的模型语言，被很多人认为（包括我）远优于 Erb。
* [kaminari](https://github.com/amatsuda/kaminari) - 很棒的分页解决方案。
* [machinist](https://github.com/notahat/machinist) - 假数据不好玩，Machinist 才好玩。
* [rspec-rails](https://github.com/rspec/rspec-rails) - RSpec 是 Test::MiniTest 的取代者。我不高度推荐 RSpec。 rspec-rails 提供了 RSpec 的 Rails 整合。
* [sidekiq](https://github.com/mperham/sidekiq) - Sidekiq 或许是在你的 Rails app 运行后台工作最简单并且普遍的扩展方式。
* [simple_form](https://github.com/plataformatec/simple_form) - 一旦用过 simple_form（或 formatastic），你就不想听到关于 Rails 缺省的表单。它是一个创造表单很棒的DSL。它拥有一种非常棒的 DSL 来
  构建表单并且没有理由不去标记（simple_form）。
* [simplecov-rcov](https://github.com/fguillen/simplecov-rcov) - 为了 SimpleCov 打造的 RCov formatter。若你想使用 SimpleCov 搭配 Hudson 持续整合服务器，很有用。
* [simplecov](https://github.com/colszowka/simplecov) - 代码覆盖率工具。不像 RCov，完全兼容 Ruby 1.9。产生精美的报告。必须用！
* [slim](http://slim-lang.com) - Slim 是一个简洁的模版语言，被视为是远远优于 HAML(Erb 就更不用说了)的语言。唯一会阻止大规模地使用它的是，主流IDE及编辑器的支持不好。它的性能是非凡的。
* [spork](https://github.com/timcharper/spork) - 一个给测试框架（现今 RSpec 或 Cucumber）用的 DRb 服务器，每次运行前确保分支出一个乾净的测试状态。 简单的说，预载很多测试环境的结果是大幅降低你的测试启动时间，绝对必须用！
* [sunspot](https://github.com/sunspot/sunspot) - 基于 SOLR 的全文检索引擎。

这不是完整的清单，以及其它的 gem 也可以在之后加进来。以上清单上的所有 gems 皆经测试，处于活跃开发阶段，有社群以及代码的质量很高。

## Flawed Gems 缺陷的 Gems

这是一个有问题的或被别的 gem 取代的 gem 清单。你应该在你的项目里避免使用它们。

* [rmagick](http://rmagick.rubyforge.org/) - 这个 gem 因大量消耗内存而声名狼藉。使用 [minimagick](https://github.com/probablycorey/mini_magick) 来取代。
* [autotest](http://www.zenspider.com/ZSS/Products/ZenTest/) - 自动测试的老旧解决方案。远不如 [guard](https://github.com/guard/guard) 及 [watchr](https://github.com/mynyml/watchr)。
* [rcov](https://github.com/relevance/rcov) - 代码覆盖率工具，不兼容 Ruby 1.9。使用 [SimpleCov](https://github.com/colszowka/simplecov)  来取代。
* [therubyracer](https://github.com/cowboyd/therubyracer) - 极度不鼓励在生产模式使用这个 gem，它
  消耗大量的内存。我会推荐使用 node.js 来取代。

这仍是一个完善中的清单。请告诉我受人欢迎但有缺陷的 gems 。

## Managing processes

* 如果你的项目依赖于各种外部的进程使用 [foreman](https://github.com/ddollar/foreman) 来管理它们。

# Testing Rails applications 测试 Rails 应用程序

或许 BDD 是实现新特性的最好途径。你从写一些高阶的特性测试（通常使用Cucumber），然后使用这些测试来驱动特性的实现。首先你给特性的写 view spec，并通过这些 spec 来创建相关的 view。之后，你为 controller 创建 spec（其将会传递数据给 views）并且通过这些 spec 来实现控制器。最后你实现 model 的 specs 以及 model 自身。

## Cucumber

* 用 `@wip` （work in progress）标签标记你未完成的场景。这些场景不纳入测试（账单），并且不标记为测试失败。当完成一个未完成并且实现了其功能的测试，为了将这个场景加入测试套件应该移除 `@wip` 标签。
* 设置你默认的配置文件排除标记为 `@javascript`的场景。他们（需要）使用浏览器来测试，推荐禁用它们来提高在一般场景中执行的速度。
* 替标记著 `@javascript` 的场景配置另一个配置文件。
  * 配置文件可在 `cucumber.yml` 文件里配置。

        ```Ruby
        # 配置文件的定义：
        profile_name: --tags @tag_name
        ```

  * 带指令运行一个配置文件：

        ```
        cucumber -p profile_name
        ```

* 如果使用 [fabrication](http://fabricationgem.org/) 来替代 fixtures，使用预订的 [fabrication steps](http://fabricationgem.org/#!cucumber-steps)。
* 不要使用旧的 `web_steps.rb` 步骤定义！[The web steps were removed from the latest version of Cucumber.](http://aslakhellesoy.com/post/11055981222/the-training-wheels-came-off) 他们的使用会导致产生冗余的场景其并没有合适的反映出应用领域。
* 当检查一元素的呈现的可视文字时(link, button, etc.)，检查元素的文字而不是检查 id。这样可以查出 i18n 的问题。
* 给同种类对象的不同的功能创建分割的特性：

    ```Ruby
    # bad
    Feature: Articles
    # ... feature  implementation ...

    # good
    Feature: Article Editing
    # ... feature  implementation ...

    Feature: Article Publishing
    # ... feature  implementation ...

    Feature: Article Search
    # ... feature  implementation ...

    ```

* 每个 feature 有三个主要的组件
  * Title 标题
  * Narrative 叙述（描述） - 关于 feature 的一个简单的解释。
  * Acceptance criteria 接受标准 - 一系列的由独立的步骤组成的场景。
* 最常见的格式称为 Connextra 格式。

    ```Ruby
    In order to [benefit] ...
    A [stakeholder] ...
    Wants to [feature] ...
    ```

这是最常见但不是必须的格式，叙述（narrative）可以是取决于功能复杂度的任何文字。

* 自由地使用场景概述（Scenario Outlines）来保持场景 DRY (keep your scenarios DRY)。

    ```Ruby
    Scenario Outline: User cannot register with invalid e-mail
      When I try to register with an email "<email>"
      Then I should see the error message "<error>"

    Examples:
      |email         |error                 |
      |              |The e-mail is required|
      |invalid email |is not a valid e-mail |
    ```

* 场景的步骤放在 `step_definitions` 目录下的 `.rb` 文件。步骤文件命名惯例为 `[description]_steps.rb`。步骤根据不同的标准放在不同的文件里。每一个功能可能有一个步骤文件 (`home_page_steps.rb`)。也可能一个步骤文件 (`articles_steps.rb`)对应于某个特定对象的所有的 features。

* 使用多行步骤来避免重复

    ```Ruby
    Scenario: User profile
      Give I am logged in as a user "John Doe" with an e-mail "user@test.com"
      when I go to my profile
      Then I should see the following information:
        |First name|John         |
        |Last name |Doe          |
        |E-mail    |user@test.com|

    # the step
    Then /^I should see the following information:$/ do |table|
      table.raw.each do |field, value|
        find_field(field).value.should =~ /#{value}/
      end
    end
    ```

## RSpec

* 一个例子使用一个期望值。

    ```Ruby
    # bad
    describe ArticlesController do
      # ...
      describe 'GET new' do
        it 'assigns new article and renders the new article template' do
          get :new
          assigns[:article].should be_a_new Article
          response.should render_template :new
        end
      end

      # ...
    end

    # good
    describe 'GET new' do
      it 'assigns a new article' do
        get :new
        assigns[:article].should be_a_new Article
      end

      it 'renders the new article template' do
        get :new
        response.should render_template :new
      end

    end
    ```

* 大量使用 `describe` 和 `context`
* 按照如下地示例给 `describe` 区块命名：
  * 对于 non-methods 使用 "description"
  * 实例方法使用 `#` "#method"
  * 类方法使用 `.` ".method"

    ```Ruby
    Class Article
      def summary
        # ...
      end

      def self.latest
        # ...
      end
    end

    # the spec...
    describe Article
      describe '#summary'
        # ...
      end

      describe '.latest'
        # ...
      end
    end
    ```

* 使用 [fabricators](http://fabricationgem.org/) 来生成测试对象。
* 大量使用 [mocks](https://www.relishapp.com/rspec/rspec-rails/v/2-4/docs/mocks/mock-model) 与 [stubs](https://www.relishapp.com/rspec/rspec-rails/v/2-4/docs/mocks/mock-model)。#模拟和存根
  * mock_model

    The mock_model method generates a test double that acts like an Active Model model. This is different from the stub_model method which generates an instance of a real ActiveModel class.
    The benefit of mock_model over stub_model is that its a true double, so the examples are not dependent on the behaviour (or mis-behaviour), or even the existence of any other code. **If you're working on a controller spec and you need a model that doesn't exist, you can pass mock_model a string and the generated object will act as though its an instance of the class named by that string.**
  * stub_model

    **The stub_model method generates an instance of a Active Model model.**
    While you can use stub_model in any example (model, view, controller, helper), it is especially useful in view examples, which are inherently more state-based than interaction-based.

    ```Ruby
    # mocking a model
    article = mock_model(Article)

    # stubbing a method
    Article.stub(:find).with(article.id).and_return(article)
    ```
* 当 mocking 一个模型时，使用 as_null_object 方法。它告诉输出仅监听我们预期的消息，并忽略其它的消息。

    ```Ruby
    article = mock_model(Article).as_null_object
    ```

* 使用 `let` 代码块替代 `before(:all)` 代码块来为 spec 例子创建数据。`let` 代码块更省事。

    ```Ruby
    # use this
    let(:article) { Fabricate(:article) }

    # ... instead of this:
    before(:each) { @article = Fabricate(:article) }
    ```

* 尽可能使用 `subject`。

    ```Ruby
    describe Article do
      subject { Fabricate(:article) }

      it 'is not published on creation' do
        subject.should_not be_published
      end
    end
    ```

* 可能的话使用 `specify`。它是 `it` 的代名词但是在没有说明文字的时候更具可读性。

    ```Ruby
    # bad
    describe Article do
      before { @article = Fabricate(:article) }

      it 'is not published on creation' do
        @article.should_not be_published
      end
    end

    # good
    describe Article do
      let(:article) { Fabricate(:article) }
      specify { article.should_not be_published }
    end
    ```

* 尽可能使用 `its`。

    ```Ruby
    # bad
    describe Article do
      subject { Fabricate(:article) }

      it 'has the current date as creation date' do
        subject.creation_date.should == Date.today
      end
    end

    # good
    describe Article do
      subject { Fabricate(:article) }
      its(:creation_date) { should == Date.today }
    end
    ```

* 使用 `shared_examples` 如果你希望创建一个 spec 组其可以和很多其它测试共享。

   ```Ruby
   # bad
    describe Array do
      subject { Array.new [7, 2, 4] }

      context "initialized with 3 items" do
        its(:size) { should eq(3) }
      end
    end

    describe Set do
      subject { Set.new [7, 2, 4] }

      context "initialized with 3 items" do
        its(:size) { should eq(3) }
      end
    end

   #good
    shared_examples "a collection" do
      subject { described_class.new([7, 2, 4]) }

      context "initialized with 3 items" do
        its(:size) { should eq(3) }
      end
    end

    describe Array do
      it_behaves_like "a collection"
    end

    describe Set do
      it_behaves_like "a collection"
    end
    ```
### Views 视图测试

* view spec 的目录结构 `spec/views`要与 `app/views` 一致。例如，视图 `app/views/users`的 spec 例子被放在 `spec/views/users`。
* 视图的 specs 的命名惯例是添加 `_spec.rb` 至视图名字之后，举例来说，视图 `_form.html.haml` 有一个对应的测试叫做 `_form.html.haml_spec.rb`。
* 每个视图测试文件都需要 `spec_helper.rb`。
* 外部描述区块使用的是不含 `app/views` 部分的视图路径。在 `render` 方法没有传入参数时，是这么使用的。

    ```Ruby
    # spec/views/articles/new.html.haml_spec.rb
    require 'spec_helper'

    describe 'articles/new.html.haml' do
      # ...
    end
    ```

* 永远在视图测试使用 mock 模型。（因为）视图的目的只是显示信息。
* `assign` 方法提供实例变量（在产品生产环境中，它是）由控制器提供给视图使用的。

    ```Ruby
    # spec/views/articles/edit.html.haml_spec.rb
    describe 'articles/edit.html.haml' do
    it 'renders the form for a new article creation' do
      assign(
        :article,
        mock_model(Article).as_new_record.as_null_object
      )
      render
      rendered.should have_selector('form',
        method: 'post',
        action: articles_path
      ) do |form|
        form.should have_selector('input', type: 'submit')
      end
    end
    ```

* 偏好 capybara 否定选择器，胜于搭配肯定的 should_not 。

    ```Ruby
    # bad
    page.should_not have_selector('input', type: 'submit')
    page.should_not have_xpath('tr')

    # good
    page.should have_no_selector('input', type: 'submit')
    page.should have_no_xpath('tr')
    ```

* 当一个视图使用 helper methods 时，这些方法需要被 stubbed。Stubbing 这些 helper 方法是在 `template` 完成的：

    ```Ruby
    # app/helpers/articles_helper.rb
    class ArticlesHelper
      def formatted_date(date)
        # ...
      end
    end

    # app/views/articles/show.html.haml
    = "Published at: #{formatted_date(@article.published_at)}"

    # spec/views/articles/show.html.haml_spec.rb
    describe 'articles/show.html.html' do
      it 'displays the formatted date of article publishing'
        article = mock_model(Article, published_at: Date.new(2012, 01, 01))
        assign(:article, article)

        template.stub(:formatted_date).with(article.published_at).and_return '01.01.2012'

        render
        rendered.should have_content('Published at: 01.01.2012')
      end
    end
    ```

* 在 `spec/helpers` 目录的 helper specs 是与视图 specs 分开的。

## Controllers 控制器测试

* 对于 models 使用 mock_model，对于 models 的方法使用 stub。controller 测试应该不依赖于 model 创建（的数据）。
* 按照习惯 controller 测试仅仅需要负责如下：
  * 执行特定方法
  * 从 action 返回的数据 - assigns，等等。
  * 从 action 返回的结果 - template 渲染，重定向等等。

        ```Ruby
        # Example of a  commonly used controller spec
        # spec/controllers/articles_controller_spec.rb
        # We are interested only in the actions the controller should perform
        # So we are mocking the model creation and stubbing its methods
        # And we concentrate only on the things the controller should do
        describe ArticlesContrller do
          # The model will be used in the spec for all methods of controller
          let(:article) { mock_model(Article) }

          describe 'POST create' do
            before { Article.stub(:new).and_return(article) }

            it 'creates a new article with the given arrtibutes' do
              Article.should_receive(:new).with(title: 'The New Article Title').and_return(article)
              post :create, message: { title: 'The New Article Title' }
            end

            it 'saves the article' do
              article.should_receive(:save)
              post :create
            end

            it 'redirects to the Articles index' do
              article.stub(:save)
              post :create
              response.should redirect_to(action: 'index')
            end
          end
        end
        ```

* 当控制器 action 依据接收的参数有不同行为时，使用 context。

    ```Ruby
    # A classic example for use of contexts in a controller spec is creation or update when the object saves successfully or not.

    describe ArticlesController do
      let(:article) { mock_model(Article) }

      describe 'POST create' do
        before { Article.stub(:new).and_return(article) }

        it 'creates a new article with the given attributes' do
          Article.should_receive(:new).with(title: 'The New Article Title').and_return(article)
          post :create, article: { title: 'The New Article Title' }
        end

        it 'saves the article' do
          article.should_receive(:save)
          post :create
        end

        context 'when the article saves successfully' do
          before { article.stub(:save).and_return(true) }

          it 'sets a flash[:notice] message' do
            post :create
            flash[:notice].should eq('The article was saved successfully.')
          end

          it 'redirects to the Articles index' do
            post :create
            response.should redirect_to(action: 'index')
          end
        end

        context 'when the article fails to save' do
          before { article.stub(:save).and_return(false) }

          it 'assigns @article' do
            post :create
            assigns[:article].should be_eql(article)
          end

          it 're-renders the "new" template' do
            post :create
            response.should render_template('new')
          end
        end
      end
    end
    ```

### Models 模型测试

* 不要在 models 自己的 spec example 里 使用 mock_model 的方式测试模型。
* 使用 fabrication 来生成真实的对象。
* 使用 mock_model 别的模型或子对象是可接受的。
* 在测试里建立用于所有例子的模型（对象）来避免重复。

    ```Ruby
    describe Article
      let(:article) { Fabricate(:article) }
    end
    ```

* 加入一个例子确保 fabricated 的模型(对象)是有效的。

    ```Ruby
    describe Article
      it 'is valid with valid attributes' do
        article.should be_valid
      end
    end
    ```

* 在测试验证时，使用 `have(x).errors_on` 来指定要被验证的属性。使用 `be_valid` 不保证目标属性的（非法）的问题。（因为be_valid会验证每个问题）

    ```Ruby
    # bad
    describe '#title'
      it 'is required' do
        article.title = nil
        article.should_not be_valid
      end
    end

    # prefered
    describe '#title'
      it 'is required' do
        article.title = nil
        article.should have(1).error_on(:title)
      end
    end
    ```

* 给每个有验证的属性分别添加 `describe`。

    ```Ruby
    describe Article
      describe '#title'
        it 'is required' do
          article.title = nil
          article.should have(1).error_on(:title)
        end
      end
    end
    ```

* 当测试模型属性的唯一性时，把其它对象命名为 `another_object`。

    ```Ruby
    describe Article
      describe '#title'
        it 'is unique' do
          another_article = Fabricate.build(:article, title: article.title)
          #article.should have(1).error_on(:title)
          another_article.should have(1).error_on(:title)
        end
      end
    end
    ```

### Mailers

* 在 mailer spec 的模型应该要被模拟。mailer 不应依赖 models 创建(实例对象)。
* mailer 的 spec 应该确认如下(问题)：
  * subject 是正确的
  * receiver e-mail 是正确的
  * e-mail 寄送至正确的邮件地址
  * e-mail 包含了需要的信息

     ```Ruby
     describe SubscriberMailer
       let(:subscriber) { mock_model(Subscription, email: 'johndoe@test.com', name: 'John Doe') }

       describe 'successful registration email'
         subject { SubscriptionMailer.successful_registration_email(subscriber) }

         its(:subject) { should == 'Successful Registration!' }
         its(:from) { should == ['info@your_site.com'] }
         its(:to) { should == [subscriber.email] }

         it 'contains the subscriber name' do
           subject.body.encoded.should match(subscriber.name)
         end
       end
     end
     ```

### Uploaders

* 我们如何测试 uploader 大小调整是正确的。这里是一个  [carrierwave](https://github.com/jnicklas/carrierwave) 图片 uploader 的示例 spec：

    ```Ruby

    # rspec/uploaders/person_avatar_uploader_spec.rb
    require 'spec_helper'
    require 'carrierwave/test/matchers'

    describe PersonAvatarUploader do
      include CarrierWave::Test::Matchers

      # Enable images processing before executing the examples
      before(:all) do
        UserAvatarUploader.enable_processing = true
      end

      # Create a new uploader. The model is mocked as the uploading and resizing images does not depend on the model creation.
      before(:each) do
        @uploader = PersonAvatarUploader.new(mock_model(Person).as_null_object)
        @uploader.store!(File.open(path_to_file))
      end

      # Disable images processing after executing the examples
      after(:all) do
        UserAvatarUploader.enable_processing = false
      end

      # Testing whether image is no larger than given dimensions
      context 'the default version' do
        it 'scales down an image to be no larger than 256 by 256 pixels' do
          @uploader.should be_no_larger_than(256, 256)
        end
      end

      # Testing whether image has the exact dimensions
      context 'the thumb version' do
        it 'scales down an image to be exactly 64 by 64 pixels' do
          @uploader.thumb.should have_dimensions(64, 64)
        end
      end
    end

    ```

# Further Reading

有一些优秀的关于 Rails 风格的资源，如果你有空闲时间你应该考虑一下：

* [The Rails 3 Way](http://www.amazon.com/Rails-Way-Addison-Wesley-Professional-Ruby/dp/0321601661)
* [Ruby on Rails Guides](http://guides.rubyonrails.org/)
* [The RSpec Book](http://pragprog.com/book/achbd/the-rspec-book)
* [The Cucumber Book](http://pragprog.com/book/hwcuc/the-cucumber-book)
* [Everyday Rails Testing with RSpec](https://leanpub.com/everydayrailsrspec)

# Contributing

Nothing written in this guide is set in stone. It's my desire to work
together with everyone interested in Rails coding style, so that we could
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
