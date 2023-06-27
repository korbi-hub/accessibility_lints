# Rules


 
This folder contains linter rules concerning implementation of accessibility features. 
A  linter rule consists of:
1. a linter rule
2. a recommended fix

## class {LinterRule} extends DartLintRule

Each linter rule features a LintCode featuring the parameters:
1. ```name:``` the name displayed in the IDE when the rule is triggered
2. ```problemMessage:``` a textual description of the occurring problem
3. ```correctionMessage:``` a message containing the proposed correction for the violation

The ```run``` void is used to parse and analyze Dart code. If a certain condition is triggered during the observation, an error is reported using the  ```Error Reporter``` overridden in ```run```.

```getFixes()``` contains the possible fixes for the rule.

## class {RecommendedFix} extends DartFix

Every fix contains an overridden ```run``` method, which iterates over the provided code in the same manner as the ```run``` method of the rule. When a user clicks on the fix option in the linter message, a predefined String containing the respective fix is inserted in the place of the faulty line.