int calculatePlantState(int focusedTimeMillis) {

  if (focusedTimeMillis > 280800000) // 78 hours
    return 13;

  if (focusedTimeMillis > 266400000) // 74 hours
    return 12;

  if (focusedTimeMillis > 237600000)  // 66 hours
    return 11;

  if (focusedTimeMillis > 208800000) // 58 hours
    return 10;

  if (focusedTimeMillis > 187200000) // 52 hours
    return 9;

  if (focusedTimeMillis > 169200000) // 47 hours
    return 8;

  if (focusedTimeMillis > 151200000) // 42 hours
    return 7;

  if (focusedTimeMillis > 136800000) // 38 hours
    return 6;

  if (focusedTimeMillis > 122400000) // 34 hours
    return 5;

  if (focusedTimeMillis > 100800000) // 28 hours
    return 4;

  if (focusedTimeMillis > 79200000) // 22 hours
    return 3;

  if (focusedTimeMillis > 57600000) // 16 hours
    return 2;

  if (focusedTimeMillis > 28800000) // 8 hours
    return 1;

  return 0;
}
