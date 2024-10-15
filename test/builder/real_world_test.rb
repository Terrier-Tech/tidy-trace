require "minitest/spec"
require "minitest/autorun"
require "tidy-trace/tidier"
require "tidy-trace/builder"
require "tidy-trace/extensions/common_path_truncators"
require "tidy-trace/extensions/common_path_transformers"

describe TidyTrace, :real_world do
  it "should tidy a real-world rails action backtrace" do
    backtrace = [
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/bundler/gems/generic-pmt-processor/lib/gpp/gpp_transactor.rb:87:in `post'",
      "/Users/generic-user/Code/generic-project/app/helpers/log_decorator.rb:14:in `block (3 levels) in decorate_with_logs'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/bundler/gems/generic-pmt-processor/lib/gpp/gpp_credit_transactor.rb:542:in `post_credit_payment'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/bundler/gems/generic-pmt-processor/lib/gpp/gpp_credit_transactor.rb:173:in `pay_credit'",
      "/Users/generic-user/Code/generic-project/app/card_processors/gpp_interface.rb:273:in `charge_payment!'",
      "/Users/generic-user/Code/generic-project/app/card_processors/gpp_interface.rb:186:in `_process_simple_payment!'",
      "/Users/generic-user/Code/generic-project/app/card_processors/payment_source_interface.rb:111:in `process_simple_payment!'",
      "/Users/generic-user/Code/generic-project/app/controllers/payments_controller.rb:189:in `create'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_controller/metal/basic_implicit_render.rb:6:in `send_action'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/abstract_controller/base.rb:224:in `process_action'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_controller/metal/rendering.rb:165:in `process_action'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/abstract_controller/callbacks.rb:259:in `block in process_action'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/activesupport-7.1.4/lib/active_support/callbacks.rb:110:in `run_callbacks'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/abstract_controller/callbacks.rb:258:in `process_action'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_controller/metal/rescue.rb:25:in `process_action'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_controller/metal/instrumentation.rb:74:in `block in process_action'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/activesupport-7.1.4/lib/active_support/notifications.rb:206:in `block in instrument'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/activesupport-7.1.4/lib/active_support/notifications/instrumenter.rb:58:in `instrument'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/activesupport-7.1.4/lib/active_support/notifications.rb:206:in `instrument'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_controller/metal/instrumentation.rb:73:in `process_action'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_controller/metal/params_wrapper.rb:261:in `process_action'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/activerecord-7.1.4/lib/active_record/railties/controller_runtime.rb:32:in `process_action'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/abstract_controller/base.rb:160:in `process'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionview-7.1.4/lib/action_view/rendering.rb:40:in `process'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_controller/metal.rb:227:in `dispatch'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_controller/metal.rb:309:in `dispatch'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_dispatch/routing/route_set.rb:49:in `dispatch'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_dispatch/routing/route_set.rb:32:in `serve'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_dispatch/journey/router.rb:51:in `block in serve'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_dispatch/journey/router.rb:131:in `block in find_routes'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_dispatch/journey/router.rb:124:in `each'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_dispatch/journey/router.rb:124:in `find_routes'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_dispatch/journey/router.rb:32:in `serve'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_dispatch/routing/route_set.rb:882:in `call'",
      "/Users/generic-user/Code/generic-project/lib/middleware/http_request_error_logger.rb:32:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/rack-3.1.7/lib/rack/deflater.rb:47:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/remotipart-1.4.4/lib/remotipart/middleware.rb:32:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/rack-3.1.7/lib/rack/tempfile_reaper.rb:20:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/rack-3.1.7/lib/rack/etag.rb:29:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/rack-3.1.7/lib/rack/conditional_get.rb:43:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/rack-3.1.7/lib/rack/head.rb:15:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_dispatch/http/permissions_policy.rb:36:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_dispatch/http/content_security_policy.rb:33:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/rack-session-2.0.0/lib/rack/session/abstract/id.rb:272:in `context'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/rack-session-2.0.0/lib/rack/session/abstract/id.rb:266:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_dispatch/middleware/cookies.rb:689:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/activerecord-7.1.4/lib/active_record/migration.rb:655:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_dispatch/middleware/callbacks.rb:29:in `block in call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/activesupport-7.1.4/lib/active_support/callbacks.rb:101:in `run_callbacks'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_dispatch/middleware/callbacks.rb:28:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_dispatch/middleware/executor.rb:14:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_dispatch/middleware/actionable_exceptions.rb:16:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_dispatch/middleware/debug_exceptions.rb:29:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/web-console-4.2.1/lib/web_console/middleware.rb:132:in `call_app'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/web-console-4.2.1/lib/web_console/middleware.rb:28:in `block in call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/web-console-4.2.1/lib/web_console/middleware.rb:17:in `catch'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/web-console-4.2.1/lib/web_console/middleware.rb:17:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_dispatch/middleware/show_exceptions.rb:31:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/railties-7.1.4/lib/rails/rack/logger.rb:37:in `call_app'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/railties-7.1.4/lib/rails/rack/logger.rb:24:in `block in call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/activesupport-7.1.4/lib/active_support/tagged_logging.rb:139:in `block in tagged'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/activesupport-7.1.4/lib/active_support/tagged_logging.rb:39:in `tagged'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/activesupport-7.1.4/lib/active_support/tagged_logging.rb:139:in `tagged'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/activesupport-7.1.4/lib/active_support/broadcast_logger.rb:241:in `method_missing'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/railties-7.1.4/lib/rails/rack/logger.rb:24:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/sprockets-rails-3.4.2/lib/sprockets/rails/quiet_assets.rb:13:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_dispatch/middleware/remote_ip.rb:92:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_dispatch/middleware/request_id.rb:28:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/rack-3.1.7/lib/rack/method_override.rb:28:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/rack-3.1.7/lib/rack/runtime.rb:24:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_dispatch/middleware/server_timing.rb:59:in `block in call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_dispatch/middleware/server_timing.rb:24:in `collect_events'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_dispatch/middleware/server_timing.rb:58:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_dispatch/middleware/executor.rb:14:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_dispatch/middleware/static.rb:25:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/rack-3.1.7/lib/rack/sendfile.rb:114:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/actionpack-7.1.4/lib/action_dispatch/middleware/host_authorization.rb:141:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/vite_ruby-3.3.4/lib/vite_ruby/dev_server_proxy.rb:22:in `perform_request'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/rack-proxy-0.7.7/lib/rack/proxy.rb:87:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/railties-7.1.4/lib/rails/engine.rb:536:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/puma-5.6.5/lib/puma/configuration.rb:252:in `call'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/puma-5.6.5/lib/puma/request.rb:77:in `block in handle_request'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/puma-5.6.5/lib/puma/thread_pool.rb:340:in `with_force_shutdown'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/puma-5.6.5/lib/puma/request.rb:76:in `handle_request'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/puma-5.6.5/lib/puma/server.rb:443:in `process_client'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/puma-5.6.5/lib/puma/thread_pool.rb:147:in `block in spawn_thread'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/logging-2.3.1/lib/logging/diagnostic_context.rb:474:in `block in create_with_logging_context'",
    ]

    path_root = "/Users/generic-user/Code/generic-project"
    gem_root = "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0"
    tidier = TidyTrace::Builder.new
      .truncate_all { |all|
        all
          .truncate_project_path(path_root:)
          .truncate_not_bin_path(path_root:)
          .truncate_not_local_rails_middleware_path(path_root:)
      }
      .truncate_project_path(path_root:)
      .transform_gem_paths(gem_root:)
      .transform_project_paths(path_root:)
      .build

    actual = tidier.tidy(backtrace)

    expected = [
      "bundler/gems/generic-pmt-processor/lib/gpp/gpp_transactor.rb:87:in `post'",
      "./app/helpers/log_decorator.rb:14:in `block (3 levels) in decorate_with_logs'",
      "bundler/gems/generic-pmt-processor/lib/gpp/gpp_credit_transactor.rb:542:in `post_credit_payment'",
      "bundler/gems/generic-pmt-processor/lib/gpp/gpp_credit_transactor.rb:173:in `pay_credit'",
      "./app/card_processors/gpp_interface.rb:273:in `charge_payment!'",
      "./app/card_processors/gpp_interface.rb:186:in `_process_simple_payment!'",
      "./app/card_processors/payment_source_interface.rb:111:in `process_simple_payment!'",
      "./app/controllers/payments_controller.rb:189:in `create'",
    ]

    assert_equal expected, actual
  end

  it "should tidy a real-world rake backtrace" do
    backtrace = [
      "/Users/generic-user/Code/generic-project/lib/tasks/scratch.rake:13:in `raise_error!'",
      "/Users/generic-user/Code/generic-project/lib/tasks/scratch.rake:4:in `block (2 levels) in <top (required)>'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/rake-13.2.1/lib/rake/task.rb:281:in `block in execute'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/rake-13.2.1/lib/rake/task.rb:281:in `each'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/rake-13.2.1/lib/rake/task.rb:281:in `execute'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/rake-13.2.1/lib/rake/task.rb:219:in `block in invoke_with_call_chain'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/rake-13.2.1/lib/rake/task.rb:199:in `synchronize'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/rake-13.2.1/lib/rake/task.rb:199:in `invoke_with_call_chain'",
      "/Users/generic-user/Code/generic-project/lib/tasks/task_runs.rake:102:in `block in invoke'",
      "/Users/generic-user/Code/generic-project/app/models/task_run.rb:157:in `do_logged!'",
      "/Users/generic-user/Code/generic-project/lib/tasks/task_runs.rake:101:in `invoke'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/rake-13.2.1/lib/rake/application.rb:188:in `invoke_task'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/rake-13.2.1/lib/rake/application.rb:138:in `block (2 levels) in top_level'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/rake-13.2.1/lib/rake/application.rb:138:in `each'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/rake-13.2.1/lib/rake/application.rb:138:in `block in top_level'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/rake-13.2.1/lib/rake/application.rb:147:in `run_with_threads'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/rake-13.2.1/lib/rake/application.rb:132:in `top_level'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/railties-7.1.4/lib/rails/commands/rake/rake_command.rb:27:in `block (2 levels) in perform'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/rake-13.2.1/lib/rake/application.rb:214:in `standard_exception_handling'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/railties-7.1.4/lib/rails/commands/rake/rake_command.rb:27:in `block in perform'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/railties-7.1.4/lib/rails/commands/rake/rake_command.rb:44:in `block in with_rake'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/rake-13.2.1/lib/rake/rake_module.rb:59:in `with_application'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/railties-7.1.4/lib/rails/commands/rake/rake_command.rb:41:in `with_rake'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/railties-7.1.4/lib/rails/commands/rake/rake_command.rb:20:in `perform'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/railties-7.1.4/lib/rails/command.rb:156:in `invoke_rake'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/railties-7.1.4/lib/rails/command.rb:73:in `block in invoke'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/railties-7.1.4/lib/rails/command.rb:149:in `with_argv'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/railties-7.1.4/lib/rails/command.rb:69:in `invoke'",
      "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0/gems/railties-7.1.4/lib/rails/commands.rb:18:in `<top (required)>'",
      "<internal:/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/site_ruby/3.3.0/rubygems/core_ext/kernel_require.rb>:37:in `require'",
      "<internal:/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/site_ruby/3.3.0/rubygems/core_ext/kernel_require.rb>:37:in `require'",
      "/Users/generic-user/Code/generic-project/bin/rails:4:in `<main>'",
    ]

    path_root = "/Users/generic-user/Code/generic-project"
    gem_root = "/Users/generic-user/.rbenv/versions/3.3.4/lib/ruby/gems/3.3.0"
    tidier = TidyTrace::Builder.new
      .truncate_all { |all|
        all
          .truncate_project_path(path_root:)
          .truncate_not_bin_path(path_root:)
          .truncate_not_local_rails_middleware_path(path_root:)
      }
      .truncate_project_path(path_root:)
      .transform_gem_paths(gem_root:)
      .transform_project_paths(path_root:)
      .build

    actual = tidier.tidy(backtrace)

    expected = [
      "./lib/tasks/scratch.rake:13:in `raise_error!'",
      "./lib/tasks/scratch.rake:4:in `block (2 levels) in <top (required)>'",
      "gems/rake-13.2.1/lib/rake/task.rb:281:in `block in execute'",
      "gems/rake-13.2.1/lib/rake/task.rb:281:in `each'",
      "gems/rake-13.2.1/lib/rake/task.rb:281:in `execute'",
      "gems/rake-13.2.1/lib/rake/task.rb:219:in `block in invoke_with_call_chain'",
      "gems/rake-13.2.1/lib/rake/task.rb:199:in `synchronize'",
      "gems/rake-13.2.1/lib/rake/task.rb:199:in `invoke_with_call_chain'",
      "./lib/tasks/task_runs.rake:102:in `block in invoke'",
      "./app/models/task_run.rb:157:in `do_logged!'",
      "./lib/tasks/task_runs.rake:101:in `invoke'",
    ]

    assert_equal expected, actual
  end
end