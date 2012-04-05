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

### ActiveResource

* 当 `HTTP` 响应的是与现有不同的格式（XML 和 JSON）或者需要解析某些额外的格式，创建你自己的 format 并且在类中使用。定制的格式应该属于下面四类方法：`extension`， `mime_type`，`encode` 和 `decode`。

    ```Ruby
    module ActiveResource
      module Formats
        module Extend
          module CSVFormat
            extent self

            def extension
              'csv'
            end

            def mime_type
              'text/csv'
            end

            def encode(hash, options = nil)
              # Encode the data in the new format and return it
            end

            def decode(csv)
              # Decode the data from the new format and return it
            end
          end
        end
      end
    end

    class User < ActiveResource::Base
      self.format = ActiveResource::Formats::Extend::CSVFormat

      ...
    end
    ```

* 如果需要发送扩展名的请求，覆写 `ActiveResource::Base` 的 `element_path` 及 `collection_path` 方法，并移除扩展名部份。

    ```Ruby
    class User < ActiveResource::Base
      ...

      def self.collection_path(prefix_options = {}, query_options = nil)
        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        "#{prefix(prefix_options)}#{collection_name}/#{URI.parser.escape id.to_s}#{query_string(query_options)}"
      end
    end
    ```

    如有任何改动网址的需求时，这些方法也可以被覆写。

## Migrations

* 将 `schema.rb` 置于版本控制中。
* 使用 `rake db:scheme:load` 取代 `rake db:migrate` 来初始化空的数据库。
* 使用 `rake db:test:prepare` 来更新测试数据库结构。
* 避免在表里设置缺省数据。使用模型层来取代。

    ```Ruby
    def amount
      self[:amount] or 0
    end
    ```

    然而 `self[:attr_name]` 的使用被视为相当常见的，你也可以考虑使用更罗嗦的（争议地可读性更高的） `read_attribute` 来取代：

    ```Ruby
    def amount
      read_attribute(:amount) or 0
    end
    ```

* 当编写结构性的迁移时（加入表或字段位），使用 Rails 3.1 的新方式来迁移， 使用 `change` 方法取代 `up` 与 `down` 方法。

    ```Ruby
    # the old way
    class AddNameToPerson < ActiveRecord::Migration
      def up
        add_column :person, :name, :string
      end

      def down
        remove_column :person, :name
      end
    end

    # the new prefered way
    class AddNameToPerson < ActiveRecord::Migration
      def change
        add_column :person, :name, :string
      end
    end
    ```

## Views

* 不要直接从视图调用模型层。
* 不要在视图中构造复杂的格式，把它们输出到视图 `helper` 的一个方法或是模型。
* 使用 `partial` 模版和布局来减少重复的代码
* 加入 [client side validation](https://github.com/bcardarella/client_side_validations) 到定制的 validators。要做的步骤有：
  * 声明一个继承 `ClientSideValidations::Middleware::Base` 的定制验证 

        ```Ruby
        module ClientSideValidations::Middleware
          class Email < Base
            def response
              if request.params[:email] =~ /^([^@\s]+)@((?:[-a-z0-9]+[a-z]{2,}))$/i
                  self.status = 200
                else
                  self.status = 404
                end
                super
              end
            end
          end
        end
        ```

  * 新建一个文件 `public/javascripts/rails.validations.custom.js.coffee` 并在你的 `application.js.coffee` 文件加入一个它的引用：

        ```Ruby
        # app/assets/javascripts/application.js.coffee
        # = require rails.validations.custom
        ```
  * 添加你的 client-side validator：

        ```Ruby
        # public/javascripts/rails.validations.custom.js.coffee
        ClientSideValidations.validations.remote['email'] = (element, options) ->
          if $.ajax({
            url: '/validators/email.json',
            data: { email: element.val() },
            async: false
          }).status == 404
            return options.message || 'invalid e-mail format'
          end
        ```

## Internationalization 国际化

* 视图、模型与控制器里不应设置字符串或者其他语言相关设置。这些文字应搬到在 `config/locales` 下的语言文件里。
* 当 ActiveRecord 模型的标签需要被翻译时，使用 `activerecord` 作用域:

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
  * 当使用了额外的目录来组织 locale 文件之时，为了要载入这些目录，要在 application.rb 文件里描述这些目录。
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
    # use thsi call
    I18n.t 'activerecord.errors.messages.record_invalid'

    # instead of this
    I18n.t :record_invalid, :scope => [:activerecord, :errors, :messages]
    ```
* 关于 Rails i18n 更详细的信息可以在这里找到 [Rails Guides](http://guides.rubyonrails.org/i18n.html)。

## Assets

利用 [assets pipeline](http://guides.rubyonrails.org/asset_pipeline.html) 来合理的组织应用的结构。

The asset pipeline provides a framework to concatenate and minify or compress JavaScript and CSS assets. It also adds the ability to write these assets in other languages such as CoffeeScript, Sass and ERB.

* `asset pipeline` 提供了一个框架来组合精简或者编译 JavaScrip 和 CSS assets。它同样也使得用其他语言如 CoffeScript， Sass 和 ERB 编写 assets 成为可能。
* 第三方代码比如 [jQuery](http://jquery.com/) 或者 [bootstrap](http://twitter.github.com/bootstrap/) 应该被放在 `vendor/assets` 中。
* 如果可能，使用 gem 化的 assets 版本。(如： [jquery-rails](https://github.com/rails/jquery-rails))。

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
* 提供一个缺省的主机名。

    ```Ruby
    # config/environments/development.rb
    config.action_mailer.default_url_options = {host: "#{local_ip}:3000"}


    # config/environments/production.rb
    config.action_mailer.default_url_options = {host: 'your_site.com'}

    # in your mailer class
    default_url_options[:host] = 'your_site.com'
    ```

* 如果你需要在email中使用一个到站点的连接，通常使用 `_url` 而不是 `_path` 方法。`_url` 方法包含主机名但是 `_path` 方法却不包含。

    ```Ruby
    # wrong
    You can always find more info about this course
    = link_to 'here', url_for(course_path(@course))

    # right
    You can alway find more info about this course
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

* 应避免页面产生响应时寄送 email。若多个 email 寄送时，会造成了页面载入延迟，以及请求可能超时。使用 [delayed_job](https://github.com/tobi/delayed_job) gem 的帮助来克服在背景处理寄送 email 的问题。

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

* [active_admin](https://github.com/gregbell/active_admin) - 通过ActiveAdmin 你创建你的 Rails 应用程序的 admin 界面好像玩一样。你可以得到一个漂亮的仪表盘，CRUD UI 以及更多。非常灵活以及定制性（很强）。
* [capybara](https://github.com/jnicklas/capybara) - Capybara 旨在简化整合测试 Rack 应用的过程，像是 Rails、Sinatra 或 Merb。Capybara 模拟了真实用户使用 web 应用的互动。 它与你测试在运行的驱动无关，并原生搭载 Rack::Test 及 Selenium 支持。透过外部 gem 支持 HtmlUnit、WebKit 及 env.js 。与 RSpec & Cucumber 一起使用工作良好。
* [carrierwave](https://github.com/jnicklas/carrierwave) - Rails 终极文件上传解决方案。支持上传档案（及很多其它的酷玩意儿的）的本地储存与云储存。与 ImageMagick 的图片后期处理整合得非常好。
* [client_side_validations](https://github.com/bcardarella/client_side_validations) - 一个美妙的 gem ，为你依据现有的服务器端的模型验证自动产生 Javascript 用户端验证。高度推荐！
* [compass-rails](https://github.com/chriseppstein/compass)  一个优秀的 gem，添加了某些 css 框架的支持。包括了 sass mixin 的 collection（集合），让你减少 css 文件的代码并帮你解决浏览器兼容问题。
* [cucumber-rails](https://github.com/cucumber/cucumber-rails) - Cucumber 是一个由 Ruby 所写，开发功能测试的顶级工具。 cucumber-rails 提供了 Cucumber 的 Rails 整合。
* [devise](https://github.com/plataformatec/devise) - Devise 是 Rails 应用的一个完整解决方案。多数情况偏好使用 devise 来开始你的客制验证方案。
* [fabrication](http://fabricationgem.org/) - 一个很好的假数据产生器。
* [factory_girl](https://github.com/thoughtbot/factory_girl) - 另一个 fabrication 的选择。一个成熟的假数据产生器。 Fabrication 的精神领袖先驱。
* [faker](http://faker.rubyforge.org/) -  实用的 gem 来产生仿造的数据（名字、地址，等等）。
* [feedzirra](https://github.com/pauldix/feedzirra) Feedzirra is a feed library that is designed to get and update many feeds as quickly as possible。
* [friendly_id](https://github.com/norman/friendly_id) - 通过使用某些具描述性的模型属性，而不是使用 id，允许你创建 human-readable 的网址。
* [guard](https://github.com/guard/guard) - 极佳的 gem 监控文件变化及任务的调用。搭载了很多实用的扩充。远优于 autotest 与 watchr。
* [haml-rails](https://github.com/indirect/haml-rails) - haml-rails 提供了 Haml 的 Rails 整合。
* [haml](http://haml-lang.com) Haml 是一个简洁的模型语言，被很多人认为（包括我）远优于 Erb。
* [kaminari](https://github.com/amatsuda/kaminari) - 很棒的分页解决方案。
* [machinist](https://github.com/notahat/machinist) - Machinist makes it easy to create objects for use in tests. It generates data for the attributes you don't care about, and constructs any necessary associated objects, leaving you to specify only the fields you care about in your test. 
* [rspec-rails](https://github.com/rspec/rspec-rails) - RSpec 是 Test::MiniTest 的取代者。我不高度推荐 RSpec。 rspec-rails 提供了 RSpec 的 Rails 整合。
* [simple_form](https://github.com/plataformatec/simple_form) - 一旦用过 simple_form（或 formatastic），你就不想听到关于 Rails 缺省的表单。它是一个创造表单很棒的DSL。
* [simplecov-rcov](https://github.com/fguillen/simplecov-rcov) - 为了 SimpleCov 打造的 RCov formatter。若你想使用 SimpleCov 搭配 Hudson 持续整合服务器，很有用。
* [simplecov](https://github.com/colszowka/simplecov) - 代码覆盖率工具。不像 RCov，完全兼容 Ruby 1.9。产生精美的报告。必须用！
* [slim](http://slim-lang.com) - Slim 是一个简洁的模版语言，被视为是远远优于 HAML(Erb 就更不用说了)的语言。唯一会阻止大规模地使用它的是，主流IDE及编辑器的支持不好。它的效能是非凡的。
* [spork](https://github.com/timcharper/spork) - 一个给测试框架（RSpec 或 现今 Cucumber）用的 DRb 服务器，每次运行前确保分支出一个乾净的测试状态。 简单的说，预载很多测试环境的结果是大幅降低你的测试启动时间，绝对必须用！
* [sunspot](https://github.com/sunspot/sunspot) - 基于 SOLR 的全文检索引擎。

这不是完整的清单，以及其它的 gem 也可以在之后加进来。以上清单上的所有 gems 皆经测试，处于活跃开发阶段，有社群以及代码的质量很高。

## Flawed Gems 缺陷的 Gems

这是一个有问题的或被别的 gem 取代的 gem 清单。你应该在你的项目里避免使用它们。

* [rmagick](http://rmagick.rubyforge.org/) - 这个 gem 因大量消耗内存而声名狼藉。使用 minimagick 来取代。
* [minimagick](https://github.com/probablycorey/mini_magick) - 自动测试的老解决方案。远不如 guard 及 [watchr](https://github.com/mynyml/watchr)。
* [rcov](https://github.com/relevance/rcov) - 代码覆盖率工具，不兼容 Ruby 1.9。使用 SimpleCov 来取代。
* [therubyracer](https://github.com/cowboyd/therubyracer) - 极度不鼓励在生产模式使用这个 gem，它消耗大量的内存。我会推荐使用 [Mustang](https://github.com/nu7hatch/mustang) 来取代。

这仍是一个完善中的清单。请告诉我受人欢迎但有缺陷的 gems 。

<<<<<<< HEAD
## Managing processes

* 如果你的项目依赖于各种外部的进程使用 [foreman](https://github.com/ddollar/foreman) 来管理它们。

# Testing Rails applications 测试 Rails 应用程序

或许BDD是实现新特性的最好途径。你从写一些高阶的特性测试（通常使用Cucumber），然后使用这些测试来驱动特性的实现。首先你给特性的视图写 spec，并使用这些 spec 来创建相关的视图。之后，你为控制器创建 spec（其将会传递数据给视图）并且通过这些 spec 来实现控制器。最后你实现模型的测试以及模型自身。

## Cucumber

* 用 `@wip` （work in progress）标签标记你未完成的场景。这些场景不纳入测试（账单），并且不标记为测试失败。当完成一个未完成并且实现了其功能的测试，为了将这个场景加入测试套件应该移除 `@wip` 标签。
* 设置你默认的配置文件排除标记为 `@javascript`的场景。他们（需要）使用浏览器来测试，推荐禁用它们来提高在一般场景中执行的速度。
  * 配置文件可在 cucumber.yml 文件里配置。
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
* 给同种类对象创建不同的功能特色：

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

* 场景的步骤放在 `step_definitions` 目录下的 `.rb` 文件。步骤文件命名惯例为 `[description]_steps.rb`。步骤根据不同的标准放在不同的文件里。每一个功能可能有一个步骤文件 (`home_page_steps.rb`)。也可能一个步骤文件 (articles_steps.rb)对应于某个特定对象的所有的feature。

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

* 使用复合的步骤来保持 scenar DRY

    ```Ruby
    # ...
    When I subscribe for news from the category "Technical News"
    # ...

    # the step:
    When /^I subscribe for news from the category "([^"]*)"$/ do category|
      steps %Q{
        When I go to the news categories page
        And I select the category #{category}
        And I click the button "Subscribe for this category"
        And I confirm the subscription
      }
    end
    ```
* 总是使用 Capybara 否定匹配来替代 should_not 搭配肯定的情况，它们会在给定的超时时重试匹配，允许你测试 ajax 动作。[See Capybara's README for more explanation](https://github.com/jnicklas/capybara)。

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
=======
>>>>>>> parent of ceeb4f8... rails-style-guide.zh-cn update to 'RSpec'

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

