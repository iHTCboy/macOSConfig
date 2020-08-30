/*
 * https://github.com/xelzmm/Love
 */

function timeElapse(date){
	var current = new Date();
	var date_in_this_year = new Date(date);
	date_in_this_year.setFullYear(current.getFullYear());
	var years = current.getFullYear() - date.getFullYear(), seconds;
	if(Date.parse(current) < Date.parse(date_in_this_year)) {
		date_in_this_year.setFullYear(current.getFullYear() - 1);
		years -= 1;
	}
	var seconds = (Date.parse(current) - Date.parse(date_in_this_year)) / 1000;
	var days = Math.floor(seconds / (3600 * 24));
	seconds = seconds % (3600 * 24);
	var hours = Math.floor(seconds / 3600);
	if (hours < 10) {
		hours = "0" + hours;
	}
	seconds = seconds % 3600;
	var minutes = Math.floor(seconds / 60);
	if (minutes < 10) {
		minutes = "0" + minutes;
	}
	seconds = seconds % 60;
	if (seconds < 10) {
		seconds = "0" + seconds;
	}
	var result = '<span class="digit">' + years + '</span> 年 <span class="digit">' + days + '</span> 天 <span class="digit">' + hours + '</span> 小时 <span class="digit">' + minutes + '</span> 分钟 <span class="digit">' + seconds + '</span> 秒'; 
	$("#clock").html(result);
}
