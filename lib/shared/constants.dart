///
/// Rules:
///

  // require_scalable_text
  const scalableTextName = 'require_scalable_text';
  const scalableTextMsg = 'To meet accessibility criteria Text widgets must contain the tesxtScaleFactor property.';
  const scalableTextCorrection = 'add textScaleFactor.';

  // require_semantics_label
  const semanticsLabelFlag = 'semanticsLabel';
  const semanticsLabelName = 'require_semantics_label';
  const semanticsLabelMsg =
      'This Widget requires a semantic label to improve the overall accessibility of this application.\n\n'
      '''A semantic label provides a full sentence to describe a widget's content.''';
  const semanticsLableCorrection = 'add a semantic label';
  // require_semantic_label
  const semanticLabelFlag = 'semanticLabel';
  const semanticLabelName = 'require_semantic_label';

  // require_semantics_widget
  const semanticsWidgetFlag = 'Semantics';
  const semanticsWidgetName = 'require_semantics_widget';
  const semanticsWidgetMsg = '''This Widget requires to be wrapped inside a Semantics widget to enable visually impaired people to access the application's content''';
  const semanticsWidgetCorrection = 'wrap widget inside a Semantics widget';

///
/// Correction Strings:
///

  // require_scalable_text
  const scalableTextFix =
      'textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3)';

  // require_semantics_label
  const semanticsLabelFix = 'semanticsLabel: semanticsLabelText';

  // requide_semantic_label
  const semanticLabelFix = 'semanticLabel: semanticLabelText';

  // default value for the SemanticsProperties parameter in a Semantics widget
  const defaultSemanticsProperties = 'SemanticsProperties(enabled: true, attributedLabel: AttributedString(string),)';

///
/// miscancellous:
///

  // list containing of the widgets that provide the semanticLabel or the semanticsLabel property
  const requireSemanticsLabel = [
    'Text',
    'TextSpan',
    'RefreshIndiocator',
    'SvgPicture',
    'SvgPicture.asset'
  ];
  const requireSemanticLabel = [
    'Icon',
    'Image',
    'Drawer',
    'AlertDialog',
  ];

  // package name
  const packageName = 'accessibility_lints';
