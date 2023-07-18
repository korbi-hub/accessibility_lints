Accessibility linter for Flutter projects

## Features

This project contains a number of rules to support Flutter developers with the implementation of accessibility features in their applications.

The linter rules have been implemented using the [custom_lint](https://pub.dev/packages/custom_lint) package.


## Usage

To use the package in your Flutter project, import it as a dependency in your ```pubspec.yaml``` file and run ```pub get```.

```yaml
  custom_lint: [latest version]
  accessibility_lints:
    git:
      url: https://github.com/korbi-hub/accessibility_lints.git
```

Additionally you have to activate the [custom_lint](https://pub.dev/packages/custom_lint) package in your ```analysis_options.yaml``` file.

```yaml
   analyzer:
       plugins:
         - custom_lint 
```
