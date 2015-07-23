# =================================
# Originally written by Helijah
# Extended by lastmin-II, 07.2015
# =================================


# inhg -> millibar

var loop0 = func {

  var mb = sprintf("%04.f", getprop("/instrumentation/altimeter/setting-inhg") * 33.8638672536);

  setprop("/instrumentation/altimeter/millibar/qnh", mb);
  setprop("/instrumentation/altimeter/millibar/unit1", chr(mb[3]));
  setprop("/instrumentation/altimeter/millibar/unit10", chr(mb[2]));
  setprop("/instrumentation/altimeter/millibar/unit100", chr(mb[1]));
  setprop("/instrumentation/altimeter/millibar/unit1000", chr(mb[0]));

  settimer(loop0, 0);
}


# inhg -> inhg units

var loop1 = func {

  var ih100 = sprintf("%04.f", getprop("/instrumentation/altimeter/setting-inhg") * 100);

  setprop("/instrumentation/altimeter/inhg/unit3", chr(ih100[3]));
  setprop("/instrumentation/altimeter/inhg/unit2", chr(ih100[2]));
  setprop("/instrumentation/altimeter/inhg/unit1", chr(ih100[1]));
  setprop("/instrumentation/altimeter/inhg/unit0", chr(ih100[0]));

  settimer(loop1, 0);
}


# ft -> ft units
#  m ->  m units

var loop2 = func {

  var altft = sprintf("%05.f", getprop("/instrumentation/altimeter/indicated-altitude-ft"));
  var altm  = sprintf("%05.f", altft * 0.3048);

  setprop("/instrumentation/altimeter/ft/unit100", chr(altft[2]));
  setprop("/instrumentation/altimeter/ft/unit1000", chr(altft[1]));
  setprop("/instrumentation/altimeter/ft/unit10000", chr(altft[0]));

  setprop("/instrumentation/altimeter/m/unit100", chr(altm[2]));
  setprop("/instrumentation/altimeter/m/unit1000", chr(altm[1]));
  setprop("/instrumentation/altimeter/m/unit10000", chr(altm[0]));

  settimer(loop2, 0);
}


loop0();

loop1();

loop2();
