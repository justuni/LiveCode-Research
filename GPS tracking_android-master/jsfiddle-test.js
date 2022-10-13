var lat1 = 39.542335;
var long1 = -104.946674;
var lat2 = 39.545366;
var long2 = -104.990925;
var R, f1, f2, f, ff, a, c, d;

//KM:
R = 6371000; // metres
f1 = lat1 * (Math.PI / 180);
f2 = lat2 * (Math.PI / 180);
f = (lat2 - lat1) * (Math.PI / 180);
ff = (long2 - long1) * (Math.PI / 180);
a = Math.sin(f / 2) * Math.sin(f / 2) +
		Math.cos(f1) * Math.cos(f2) *
		Math.sin(ff / 2) * Math.sin(ff / 2);
c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
d = (R * c) / 10 ;
alert("d is " + Math.round(d * 100 ) / 100);

//MILES:

var lat1 = 39.545304;
var long1 = -104.990985;
var lat2 = 39.545378;
var long2 = -104.990499;
var R, f1, f2, f, ff, a, c, d;

R = 3959; // metres
f1 = lat1 * (Math.PI / 180);
f2 = lat2 * (Math.PI / 180);
f = (lat2 - lat1) * (Math.PI / 180);
ff = (long2 - long1) * (Math.PI / 180);
a = Math.sin(f / 2) * Math.sin(f / 2) +
		Math.cos(f1) * Math.cos(f2) *
		Math.sin(ff / 2) * Math.sin(ff / 2);
c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
d = (R * c);
alert("Your trip was " + (d * 100 ) / 100 + " miles long.");
