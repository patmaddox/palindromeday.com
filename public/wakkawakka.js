function clickclear(thisfield, defaulttext) {
	if (thisfield.value == defaulttext) {
  	thisfield.value = "";
	}
}

function clickrecall(thisfield, defaulttext) {
  if (thisfield.value == "") {
    thisfield.value = defaulttext;
  }
}

function daysInMonth(month,year) {
  var dd = new Date(year, month, 0);
  return dd.getDate();
}

function setDayDrop(dmonth, dday, year) {
  var month = dmonth.val();
  var day = dday.val();
  dday.children('option').remove();
  var days = (month == ' ') ? 31 : daysInMonth(month,year);
  dday.append(jQuery("<option> </option>"));
  for(var i = 1; i <= days; i++) {
    dday.append(jQuery("<option value='" + i + "'>" + i + "</option>"))
  }
}

function setDay() {
  var month = jQuery('#month_select');
  var day = jQuery('#day_select');
  setDayDrop(month,day, jQuery('#year_field').val());
}
