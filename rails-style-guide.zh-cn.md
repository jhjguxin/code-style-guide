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
