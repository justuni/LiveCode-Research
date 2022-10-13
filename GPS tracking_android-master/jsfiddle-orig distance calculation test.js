
function calc() {
	var lat1 = 39.564491;
	var long1 = -104.972028;
	var lat2 = 39.564220;
	var long2 = -104.970513;
	var dist = getdistance(lat1, long1, lat2, long2);
}

function getdistance(lat1, long1, lat2, long2) {
	var R, f1, f2, f, ff, a, c, d;
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
	//alert("d is " + Math.round(d * 100 ) / 100);
	return d;
}


