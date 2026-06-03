enum IssueType {
  addressNotFound,
  noBinCollectionsFound,
  incorrectOrMissingBins,
  somethingElse;

  String get displayName {
    switch (this) {
      case IssueType.addressNotFound:
        return 'Address not found';
      case IssueType.noBinCollectionsFound:
        return 'No bin collections showing';
      case IssueType.incorrectOrMissingBins:
        return 'Wrong or missing bin dates';
      case IssueType.somethingElse:
        return 'Something else';
    }
  }
}
