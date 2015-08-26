var initAccess = function() {
	size();
	var columnWidth = $('.masonry .block:first-child').width();
	
	$('.masonry').masonry({
		itemSelector: '.block',
		columnWidth: columnWidth,
		gutterWidth: 40,
		isFitWidth: true,
		isResizable: true
	});

	$('select').change(function(e) {
		if($(this).val() === '') {
			$(this).css({'opacity':0.7});
		} else {
			$(this).css({'opacity':1});
		}
	});
	imagePreview();
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
}

function imagePreview() {
	$('input[type="file"]:not(.no_bg)').each(function() {
		$(this).on('change', function(event) {
			var drop = $(this).parent('.drop');
			var position = $(this).attr('data-position');
			var input = $(this);
		    var files = event.target.files;
		    if(files.length) {
			    var file = files[0];
			    var type = file.type;
			    if($(drop).hasClass('image')) {
				    if(type.match('image/jpg') || type.match('image/jpeg') || type.match('image/png') || type.match('image/gif')) {
					    var reader = new FileReader();
					    reader.onload = function(file) {
					      img = file.target.result;
					      $(drop).css({'background-image':'url('+img+')'});
					      $('form#'+position).addClass('can_save');
					    }
					    if(file != undefined) {
					    	reader.readAsDataURL(file);
					    }
					} else {
						console.log(type);
					}
				} else if($(drop).hasClass('video')) {
					if(type.match('video/mp4')) {
						$(drop).css({'background-image':''});
					    $('form#'+position).addClass('can_save');
					} else {
						console.log(type);
					}
				}
			} else {
				$(drop).css({'background-image':''});
			    $('form#'+position).removeClass('can_save');
			}
		});
	});
}

$(initAccess);
$(document).on('page:load', initAccess);