$(document).ready(function() {
	$('input[type=text]').focus(function() {
	  document.title = 'FOCUSED!';
	});
});
