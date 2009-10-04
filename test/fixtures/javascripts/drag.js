$(document).ready(function() {
	$('#form').droppable({
		tolerance: 'touch',
		drop: function() {
			document.title = 'DROPPED!'
		}
	});
	$('#link').draggable({
		start: function() {
			document.title = 'DRAGGING!'
		}
	});
})