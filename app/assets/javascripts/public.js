$(function() {
	$('main').addClass('fadeIn');
	fillSvgs();
	setUpSide();
	size();
	$(window).on('hashchange', function() {
		fillSvgs();
	});
	var blockWidth = parseInt($('.masonry .block').eq(0).css('width'));
	console.log(blockWidth);
	$('.masonry').masonry({
		itemSelector: '.block',
		columnWidth: blockWidth,
		gutterWidth: 40,
		isFitWidth: true
	});
	$('#logo').click(function() {
		$('body').toggleClass('about');
	});
});

$(document).on('page:load', function() {
        $('main').addClass('fadeIn');
});
$(document).on('page:fetch', function() {
        $('main').addClass('fadeOut');
});

$(window).resize(function() {
	size();
	$('.masonry').masonry('reload');
});

function fillSvgs() {
	$primary = $('#hiddenPalette').attr('data-primary');
	$secondary = $('#hiddenPalette').attr('data-secondary');
	$('.secondary_fill').each(function() {
		fill($(this).children(), $secondary);
	});
	$('.primary_fill').each(function() {
		fill($(this).children(), $primary);
	});
}

function size() {
	$border = $('#border');
	var paddingTop = parseInt($border.css('paddingTop'));
	var paddingBottom = parseInt($border.css('paddingBottom'));
	var border = parseInt($border.css('borderWidth'))*2;
	var notice = $('.notice').innerHeight();

	var padding = paddingTop + paddingBottom + border + notice;
	$border.css({
		height:h() - padding
	});

	$sideBar = $('#side_bar');
	var padding = border + notice;
	$sideBar.css({
		height:h() - border - notice
	});
}

function setUpSide() {
	$('.method').click(function(){
		var method = $(this).attr('id');
		$.ajax({
			type: "POST",
			url: method,
			success: function(result) {
				window.location.reload();
			},
			error: function(xhr, status, error) {
			}
    	});

		// if(method == 'next_gradient' || method == 'next_pattern') {
		// 	$(this).addClass('in_use');
		// }
    });

    // $('.clear').click(function(){
    // 	var parent = $(this).parent('.button').attr('id');
    // 	$(parent).removeClass('in_use');
    // });

	$('#buttons .button.swap').click(function() {
		var id = $(this).attr('id');
		$('.swapper .block').each(function() {
			$(this).children('div').each(function() {
    			var hidden = $(this).hasClass('hidden');
    			var show = $(this).hasClass(id);
    			if(show) {
    				$(this).removeClass('hidden');
    			} else if (!hidden) {
    				$(this).addClass('hidden');
    			}
    		});
		});
		$('.masonry').masonry('reload');
	});
	
}