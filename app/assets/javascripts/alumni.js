$(function(){

	$('section#alumni').masonry({
		itemSelector: '.alumnus',
		columnWidth: 280,
		gutterWidth: 40
	}, 'bindResize');

	$('.alumnus').hover(function() {
		$('#alumni').masonry();
	});

});