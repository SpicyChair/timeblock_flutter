

String convertSelectedIndexesIntoTime(Iterable<int> indexes) {

  //at first, assume that all indexes are consecutive
  //ie, first and last will be the range of the items

  var first = convertIndexToTime(indexes.first);
  var last = convertIndexToTime(indexes.last + 1);


  return "$first - $last";
}

String convertIndexToTime(int index) {
  if (index == 144) {
    return "0:00";
  }
  return "${index ~/ 6}:${index % 6}0";
}