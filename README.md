# Tidy Trace

Tidy Trace is a simple utility for tidying up ruby backtraces with no dependencies.

Tidy Trace tidies backtraces in 3 configurable steps:

 - **Truncation:** determine the last relevant backtrace line and remove all lines after it.
 - **Filtering:** remove lines from a backtrace that don't fulfill a given condition.
 - **Transforming:** mutate backtrace lines to remove noise.

Tidy Trace uses a builder interface for configuration.


## Truncation vs. Filtering

Filtering will remove lines that don't fulfill a condition, regardless of where they are in the backtrace.
Truncation finds the last line in the backtrace that meets a condition, and removes all lines after it.

The purpose of truncation is to keep the lines relevant to your actual code and remove framework code above it in the backtrace which is not useful.

## Examples

```rb
tidier = TidyTrace::Builder.new
  .filter_with { |line| line.include?('/gems/') } # filter out lines from ruby gems
  .filter_with { |line| line.include?('/ignore-me/') } # filter out lines in any `ignore-me` directory
  .transform_with { |line| line.gsub('replace-me/', '') } # remove replace-me/ in the final backtrace
  .build

tidied_backtrace = tidier.tidy(backtrace)
```

The above tidier will transform this backtrace:

```
/path/to/file.rb:1:in `method'
/path/to/another_file.rb:2:in `another_method'
/path/to/ignore-me/file.rb:3:in `ignore_method'
/path/to/another/replace-me/file.rb:4:in `some_method'
/path/to/gems/my-gem/lib/file.rb:3:in `gem_method'
```

into the following:

```
/path/to/file.rb:1:in `method'
/path/to/another_file.rb:2:in `another_method'
/path/to/another/file.rb:4:in `some_method'
```

### Filtering vs Truncation Example

This illustrates the difference between filtering and truncation with the same condition.
Given the following backtrace:

```
/path/to/gems/my-gem/lib/file.rb:3:in `gem_method'
/path/to/file.rb:1:in `method'
/path/to/gems/my-other-gem/lib/file.rb:3:in `some_method'
/path/to/gems/my-other-gem/lib/file.rb:24:in `another_method'
```

Using this configuration for filtering:

```rb
filtering_tidier = TidyTrace::Builder.new
  .filter_with { |line| !line.include?('/gems/') } # filter out lines from ruby gems
  .build

tidied_backtrace = filtering_tidier.tidy(backtrace)
```

will have this result:

```
/path/to/file.rb:1:in `method'
```

Meanwile, using this configuration for truncation:

```rb
truncating_tidier = TidyTrace::Builder.new
  .truncate_with { |line| !line.include?('/gems/') } # truncate lines after the last non gem line
  .build

tidied_backtrace = truncating_tidier.tidy(backtrace)
```

will have this result:

```
/path/to/gems/my-gem/lib/file.rb:3:in `gem_method'
/path/to/file.rb:1:in `method'
```

## Builder Extensions

The basic `TidyTrace::Builder` has methods for adding arbitrary blocks using
`truncate_with`, `filter_with`, and `transform_with`, however Tidy Trace also comes with a
set of common extensions for `TidyTrace::Builder` to truncate, filter, and transform well known backtrace elements.

Extensions are available in `TidyTrace::Extensions`.
By requiring the file for the extensions you want to use,
`TidyTrace::Builder` will automatically be extended with the methods in that file.

### Common Truncators

The common truncators extensions are kept in 'tidy-trace/extensions/common_truncators.rb'.

- `truncate_prefix(prefix)`: truncates the backtrace after the last line that starts with the given prefix.
- `truncate_not_prefix(prefix)`: truncates the backtrace after the last line that does not start with the given prefix.

### Common Filters

The common filters extensions are kept in 'tidy-trace/extensions/common_filters.rb'.

- `filter_contains(string)`: keeps lines that contain the given string.
- `filter_matches(regex)`: keeps lines that match the given regex.
- `filter_prefix(prefix)`: keeps lines that start with the given prefix.
- `reject_contains(string)`: discards lines that contain the given string.
- `reject_matches(regex)`: discards lines that match the given regex.
- `reject_prefix(prefix)`: discards lines that start with the given prefix.

### Common Transformers

The common transformers extensions are kept in 'tidy-trace/extensions/common_transformers.rb'.

- `transform_replace_prefix(prefix, replacement: "")`: replaces the given prefix with the given replacement value in the final backtrace.
- `transform_remove_line_number_and_method`: removes the line number and method name from the end of each backtrace line.

### Common Path Truncators

The common path truncators extensions are kept in 'tidy-trace/extensions/common_path_truncators.rb'.

- `truncate_project_path(path_root: Dir.pwd)`: truncates the backtrace after the last line starting with the given root path.
- `truncate_not_bin_path(path_root: Dir.pwd)`: truncates the backtrace after the last line that does not start with `bin/` directory in the given root path.
- `truncate_not_local_rails_middleware_path(path_root: Dir.pwd)`: truncates the backtrace after the last line that does not start with the `lib/middleware/` directory in the given root path.

### Common Path Filters

The common path filters extensions are kept in 'tidy-trace/extensions/common_path_filters.rb'.

- `reject_gem_paths`: discards lines that start with the system's gem directory.
- `filter_project_paths`: keeps lines that start with the project's root path.

### Common Path Transformers

The common path transformers extensions are kept in 'tidy-trace/extensions/common_path_transformers.rb'.

- `transform_gem_paths(gem_root: Gem.paths.home, replacement: '')`: replaces the system gem directory with the given replacement.
- `transform_project_paths(path_root: Dir.pwd, replacement: './')`: replaces the project directory with the given replacement.
- `transform_home_paths(home_root: Dir.home, replacement: '~/')`: replaces the user's home directory with the given replacement.

### Usage

As an example of using these extensions, we'll replicate the behavior in the first example above:

```rb
require 'tidy-trace/builder'
require 'tidy-trace/extensions/common_filters'
require 'tidy-trace/extensions/common_path_filters'
require 'tidy-trace/extensions/common_transformers'

tidier = TidyTrace::Builder.new
  .reject_gem_paths # filter out lines from ruby gems
  .reject_contains('/ignore-me/') # filter out lines in any `ignore-me` directory
  .transform_replace('replace-me/') # remove replace-me/ in the final backtrace
  .build

tidied_backtrace = tidier.tidy(backtrace)
```

### Creating your own extensions

You can create your own extensions to `TidyTrace::Builder`
by defining a module that extends `TidyTrace::Extensions::BuilderExtension`:

```rb
# my_tidy_trace_extension.rb
require 'tidy-trace/extensions/builder_extension'

module MyTidyTraceExtension
  extend TidyTrace::Extensions::BuilderExtension

  def anonymize(name)
    transform_with do |line|
      line.gsub(/#{name}/i, 'anon')
    end
  end
end

# usage
tidier = TidyTrace::Builder.new
  .anonymize('Terry')
  .build
```

## `TidyTrace.default`

There is a global default tidier available in `TidyTrace.default`.

You can configure the default tidier using `TidyTrace.configure_default`:

```rb
TidyTrace.configure_default do |builder|
  builder
    .reject_gem_paths
    .anonymize("Terry")
end
```

## Publishing

- Update version in `lib/tidy-trace/version.rb`
- run `bundle install`
- push changes