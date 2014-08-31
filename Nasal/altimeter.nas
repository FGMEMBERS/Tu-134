# ===========================
# inhg -> millibar by Helijah
# ===========================

var loop = func {

  var mb = sprintf("%04.f", getprop("/instrumentation/altimeter/setting-inhg") * 33.8638672536);

  setprop("/instrumentation/altimeter/millibar/unit1", chr(mb[3]));
  setprop("/instrumentation/altimeter/millibar/unit10", chr(mb[2]));
  setprop("/instrumentation/altimeter/millibar/unit100", chr(mb[1]));
  setprop("/instrumentation/altimeter/millibar/unit1000", chr(mb[0]));

  settimer(loop, 0);
}

loop();
