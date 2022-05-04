---
title: gem 安装 json 报错
id: 167
categories:
  - gem
date: 2016-03-08 21:06:43
tags:
---

## 问题

编译一个开源书辑时，运行 bundle install 命令报错，让安装 json -v '1.8.1'，但报错。

    sudo gem install json -v '1.8.1'

    Building native extensions.  This could take a while...
    ERROR:  Error installing json:
        ERROR: Failed to build gem native extension.

            /usr/bin/ruby1.9.1 extconf.rb
    /usr/lib/ruby/1.9.1/rubygems/custom_require.rb:36:in `require': cannot load such file -- mkmf (LoadError)
        from /usr/lib/ruby/1.9.1/rubygems/custom_require.rb:36:in `require'
        from extconf.rb:1:in `&lt;main&gt;'

    Gem files will remain installed in /var/lib/gems/1.9.1/gems/json-1.8.1 for inspection.
    Results logged to /var/lib/gems/1.9.1/gems/json-1.8.1/ext/json/ext/generator/gem_make.out

    `</pre>

    ## 解决

    添加 ruby1.9.1-dev包就可以解决这个问题了。

    <pre>`sudo apt-get install ruby1.9.1-
    
