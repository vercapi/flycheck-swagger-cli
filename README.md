# flycheck-swagger-cli

Original: https://github.com/magoyette/flycheck-swagger-cli
I only intend to add small changes to make it working for newer versions.

An Emacs Flycheck checker for OpenAPI 2 and Swagger files that uses [swagger-cli](https://github.com/BigstickCarpet/swagger-cli). YAML files and JSON files are both supported.

flycheck-swagger-cli is still under initial development and might not be stable.

## Configuration

[swagger-cli](https://github.com/BigstickCarpet/swagger-cli) must be installed.

``` shell
npm install -g swagger-cli
```

The checker can be activating by requiring this package.

``` emacs-lisp
(require 'flycheck-swagger-cli)
```

## Customizations

### Swagger files with long initial comments

By default, only the first 4000 characters of a file are scanned to find the Swagger 2.0 element. To avoid stack overflow in Emacs multi-line regex, this limit is necessary. The defcustom `flycheck-swagger-cli-predicate-regexp-match-limit` can be used to change the limit. That could be necessary for YAML files with long initial comments.
