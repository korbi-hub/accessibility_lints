/// Rules:
///
/// require_scalable_text
const scalableTextName = 'require_scalable_text';
const scalableTextMsg = 'To meet accessibility criteria Text widgets must contain the tesxtScaleFactor property.';
const scalableTextCorrection = 'add textScaleFactor.';

/// require_semantics_label
const semanticsLabelName = 'require_semantics_label';
const semanticsLabelMsg =
    'This Widget requires a semantic label to improve the overall accessibility of this application.\n\n'
    '''A semantic label provides a full sentence to describe a widget's content.''';
const semanticsLableCorrection = 'add a semantic label';

/// Correction Strings:

/// require_scalable_text
const scalableTextFix = 'textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3)';

/// require_semantics_label
/// in this case two correction messages are being provided, because the
const semanticsLabelFix = 'semanticsLabel: semanticsLabelText';
const semanticLabelFix = 'semanticLabel: semanticLabelText';

/// miscancellous:
///
/// list containing of the widgets that provide the semanticLabel or the semanticsLabel property
const requireSemanticsLabel = ['Text'];
const requireSemanticLabel = ['Icon'];
