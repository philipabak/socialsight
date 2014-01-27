jQuery.fn.topCenter=function(){return Math.max(0,($(window).height()-$(this).outerHeight())/2+$(window).scrollTop())};



jQuery(window).load(function() {
	$('.pagewrap').css({ 'margin-top': $(".pagewrap").topCenter()+'px' });	
});

$(window).resize(function(){
	$('.pagewrap').css({ 'margin-top': $(".pagewrap").topCenter()+'px' });	
});