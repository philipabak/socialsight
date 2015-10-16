jQuery(window).load(function() {
	originalCode();
});


function originalCode() {
	// Guides Filter Selects
	$('.gf_select').click(function(){
		var _dd = $(this).find('.gf_dropdown');
		$('.gf_select').find('.gf_dropdown').not($(this).find('.gf_dropdown')).hide();	
		$('.gf_select').not($(this)).removeClass('gf_active');			
		$(this).toggleClass('gf_active');		
		_dd.css("width",($(this).outerWidth()-1)+"px").toggle();		
	});
	
	$('.gf_dropdown ul li').click(function(){
		$(this).parents('.gf_select').find('span').html($(this).text());
	});
	// Guides Filter Selects End
	
	$(".sss_tooltip_wrap2").hover(
		function () {			
			var _tooltip = $(this).find('.sss_tooltip2');			
			var x2 = $(this).offset().left + _tooltip.width() + 210;			
			if (x2 > $(window).width()) { _tooltip.addClass('style_left'); }
			else { _tooltip.removeClass('style_left'); }
			_tooltip.stop(true,true).delay( 600 ).fadeIn();
		},
		function () {			
			$(this).find('.sss_tooltip2').stop(true,true).delay( 300 ).fadeOut();			
		}
	);

	$(window).scroll(function(data) {
		console.log($(window).scrollTop());
		$(".loginreg_box").css("top", 50 - $(window).scrollTop());
	})

	$('.fs_input_right_text, .showjoinus').click(function(e){
		// redirect if redirect data present
		redirect_data = $(this).data("redirect") 
		if (redirect_data && redirect_data != "") {
			window.location = redirect_data;
		}

		// Fill city in join us form if data present
		nflocation_data = $(this).data("nflocation") 
		if (nflocation_data) {
			//Remove 's from location
			nflocation_data = nflocation_data.replace(/'/g,'')			
			var city_field = $("#new_guide_city_search")
			if (city_field.length > 0) {
				city_field.val(nflocation_data);
			}
			//Fill coordinates
			geocoder = new google.maps.Geocoder();
			geocoder.geocode( { 'address': nflocation_data},
				function(results, status) {
					var ac = results[0].address_components
					var geometry = results[0].geometry
					if (ac != undefined && geometry != undefined) {
						$.each(ac, function (i, address_component) {
							if (address_component.types[0] == "country") $('#city_country_name').val(ac[0].long_name)
						})
		        $('#city_name').val(ac[0].long_name)
		        $('#city_longitude').val(geometry.location.lng())
		        $('#city_latitude').val(geometry.location.lat())
					}
				});
		}

		//Show join us form		
		$('.tab_joinus').trigger('click');		
		$('.loginreg_box').center();
		$('.loginreg_box').fadeIn();
		e.stopPropagation();
	});		
	
	$(".lightbox").lightbox();
	
	$('.sss-chb').sssCheckbox();
	
	$('#loginreg_tabs').sssTabs();

	$('.user_name').click(function(){	
		$('.user_name ul').toggle();
	});
	
	// Login Reg.
	$('.loginreg_box').click(function(e){		 
		e.stopPropagation();
	});	
	
	$('.loginreg_box').center();
	
	$('#login-trigger, .login-trigger').click(function(e){	
		$('.tab_login').trigger('click');	
		$('.loginreg_box').fadeIn();
		e.stopPropagation();
	});	
	
	// login form
	$('#loginform').submit(function(){		
		$('#loginform input').removeClass('error');
		var _valid = 1;
		
		if(!isEmail($('#loginform input[name="email"]').val())) { 
			$('#loginform input[name="email"]').vibrate({ frequency: 1000, spread: 5, duration: 500 }).addClass('error'); 
			_valid = 0;
		}
		if(!$('#loginform input[name="password"]').val().length) { 
			$('#loginform input[name="password"]').vibrate({ frequency: 1000, spread: 5, duration: 500 }).addClass('error'); 
			_valid = 0;
		}
		
		if (_valid) {return true}
		else {return false}
		
	});
	
	// reg form
	$('#new_user').submit(function(){		
		$('#new_user input').removeClass('error');
		var _valid = 1;
		
		if($.trim($('#new_user input[name="user[first_name]"]').val()).length == 0) { 
			$('#new_user input[name="user[first_name]"]').vibrate({ frequency: 1000, spread: 5, duration: 500 }).addClass('error'); 
			_valid = 0;
		}
		if($.trim($('#new_user input[name="user[last_name]"]').val()).length == 0) { 
			$('#new_user input[name="user[last_name]"]').vibrate({ frequency: 1000, spread: 5, duration: 500 }).addClass('error'); 
			_valid = 0;
		}
		if(!isEmail($('#new_user input[name="user[email]"]').val())) { 
			$('#new_user input[name="user[email]"]').vibrate({ frequency: 1000, spread: 5, duration: 500 }).addClass('error'); 
			_valid = 0;
		}
		if($.trim($('#new_user input[name="user[password]"]').val()).length == 0) { 
			$('#new_user input[name="user[password]"]').vibrate({ frequency: 1000, spread: 5, duration: 500 }).addClass('error'); 
			_valid = 0;
		}
		if($.trim($('#new_user input[name="user[password_confirmation]"]').val()).length == 0 || $.trim($('#new_user input[name="user[password]"]').val()) != $.trim($('#new_user input[name="user[password_confirmation]"]').val())) { 
			$('#new_user input[name="user[password_confirmation]"]').vibrate({ frequency: 1000, spread: 5, duration: 500 }).addClass('error'); 
			_valid = 0;
		}

		if($.trim($('#new_user input[name="user[password]"]').val()).length < 6) { 
			$('#new_user input[name="user[password]"]').vibrate({ frequency: 1000, spread: 5, duration: 500 }).addClass('error'); 
			$('#new_user input[name="user[password_confirmation]"]').vibrate({ frequency: 1000, spread: 5, duration: 500 }).addClass('error'); 
			_valid = 0;
		}
			
		if ($('#city_name').val().length == 0 ||
			  $('#city_longitude').val().length == 0 ||
		    $('#city_latitude').val().length == 0) {
			$('input[name="new_guide_city_search"]').vibrate({ frequency: 1000, spread: 5, duration: 500 }).addClass('error'); 
			_valid = 0;			
		}


		if (_valid) {return true}
		else {return false}
		
	});
		
	$("#user_sex, #user_birth_date_3i, #user_birth_date_2i, #user_birth_date_1i").select2();
		
	// Login Reg. End	
	$('.tooltip').tooltipster({
		interactive: true,
		maxWidth: 200
	});
	
	 $('.anythingFader').anythingFader({
		autoPlay: true,                 // This turns off the entire FUNCTIONALY, not just if it starts running or not.
		delay: 5000,                    // How long between slide transitions in AutoPlay mode
		startStopped: false,            // If autoPlay is on, this can force it to start stopped
		animationTime: 500,             // How long the slide transition takes
		hashTags: true,                 // Should links change the hashtag in the URL?
		buildNavigation: false,          // If true, builds and list of anchor links to link to each slide
		pauseOnHover: true,             // If true, and autoPlay is enabled, the show will pause on hover
		startText: "Go",                // Start text
		stopText: "Stop",               // Stop text                
	});
	
	$(window).scroll(function () {
        if ($(this).scrollTop() > 70) {
            $('.guides_setfixed').addClass("fixed_head");
        } else {
            $('.guides_setfixed').removeClass("fixed_head");
        }
    });
	
	$(".gc_image").hover(
		function () {						
			$(this).find('.gc_addtofavorite').stop().slideDown();
		},
		function () {			
			$(this).find('.gc_addtofavorite').stop().slideUp();
		}
	);	 
	
	$(".htsu-navmenu").hiwaccord({
		hiwaccord:true,
		speed: 500,
		closedSign: '',
		openedSign: ''
	});
	
	$('.alert .close').click(function(){
		$(this).parents('.alert').fadeOut();
	});
	
}	

$(document).click(function(e) {	
	$('.loginreg_box').fadeOut();
});

$(document).keypress(function(e){		
	switch(e.keyCode) {
		case 27:
			if ($('.loginreg_box').css("display") == "block") { $('.loginreg_box').fadeOut(); }
		break;
	}
});

// checkbox csere
(function($){
	$.fn.extend({
		sssCheckbox: function(options) {

			var defaults = {
				defClass: 'sss-checkbox',
				checkedClass: 'sss-checkbox-checked',
				uncheckedClass: 'sss-checkbox-unchecked'
			};
			var options = $.extend(defaults, options);

			return this.each(function() {
				var o = options;
				var t = $(this);
				var ti = $(this).find('input');
				var tl = $(this).find('label');

				ti.hide();

				div = $(document.createElement('div'));				
				div_wrap = $(document.createElement('div')).addClass('filter_checkbox').append(div);
				ti.after(div_wrap);
				
				div.click(function(){
				console.log(ti.is(":checked"));
					if(ti.is(":checked")){
						$(this).removeClass(o.checkedClass).addClass(o.uncheckedClass);
						ti.prop('checked', false);
						
					}else {
						$(this).removeClass(o.uncheckedClass).addClass(o.checkedClass)
						ti.prop("checked", true);
					}					
				});
				
				tl.click(function(){															
					if(ti.is(":checked")){						
						$(this).parent().find('.sss-checkbox').removeClass(o.checkedClass).addClass(o.uncheckedClass);						
						ti.prop('checked', false);
					}else {						
						$(this).parent().find('.sss-checkbox').removeClass(o.uncheckedClass).addClass(o.checkedClass)
						ti.prop('checked', true);
					}
				});				
				
				if(ti.is(":checked")){
					div.addClass(o.defClass+' '+o.checkedClass);
				}else {
					div.addClass(o.defClass+' '+o.uncheckedClass);
				}
				
				
			});
		}
	});

})(jQuery);

// tab
(function($){
	$.fn.extend({
		sssTabs: function(options) {

			var defaults = {
				active:'active_tab'
			};
			var options = $.extend(defaults, options);

			return this.each(function() {
				var o = options;
				var t = $(this);				
				var menu_list = t.find('li');				
				var active_tab = t.find('li.'+o.active);				
				var prefix = t.attr("id");						
				
				$('.'+prefix+'_contents').children().hide();
				
				if (active_tab.length) {
					$('#'+active_tab.attr('class').split(' ')[0]).show();
				}
				
				menu_list.click(function(){
					menu_list.removeClass(o.active);
					$('.'+prefix+'_contents').children().hide();					
					$(this).addClass(o.active);
					$('#'+$(this).attr('class').split(' ')[0]).show();
				});
				
			});
		}
	});

})(jQuery);
(function(d,f,g,b){var e="tooltipster",c={animation:"fade",arrow:true,arrowColor:"",content:"",delay:200,fixedWidth:0,maxWidth:0,functionBefore:function(l,m){m()},functionReady:function(l,m){},functionAfter:function(l){},icon:"(?)",iconDesktop:false,iconTouch:false,iconTheme:".tooltipster-icon",interactive:false,interactiveTolerance:350,offsetX:0,offsetY:0,onlyOne:true,position:"top",speed:350,timer:0,theme:".tooltipster-default",touchDevices:true,trigger:"hover",updateAnimation:true};function h(m,l){this.element=m;this.options=d.extend({},c,l);this._defaults=c;this._name=e;this.init()}function j(){return !!("ontouchstart" in f)}function a(){var l=g.body||g.documentElement;var n=l.style;var o="transition";if(typeof n[o]=="string"){return true}v=["Moz","Webkit","Khtml","O","ms"],o=o.charAt(0).toUpperCase()+o.substr(1);for(var m=0;m<v.length;m++){if(typeof n[v[m]+o]=="string"){return true}}return false}var k=true;if(!a()){k=false}h.prototype={init:function(){var r=d(this.element);var n=this;var q=true;if((n.options.touchDevices==false)&&(j())){q=false}if(g.all&&!g.querySelector){q=false}if(q==true){if((this.options.iconDesktop==true)&&(!j())||((this.options.iconTouch==true)&&(j()))){var m=r.attr("title");r.removeAttr("title");var p=n.options.iconTheme;var o=d('<span class="'+p.replace(".","")+'" title="'+m+'">'+this.options.icon+"</span>");o.insertAfter(r);r.data("tooltipsterIcon",o);r=o}var l=d.trim(n.options.content).length>0?n.options.content:r.attr("title");r.data("tooltipsterContent",l);r.removeAttr("title");if((this.options.touchDevices==true)&&(j())){r.bind("touchstart",function(t,s){n.showTooltip()})}else{if(this.options.trigger=="hover"){r.on("mouseenter.tooltipster",function(){n.showTooltip()});if(this.options.interactive==true){r.on("mouseleave.tooltipster",function(){var t=r.data("tooltipster");var u=false;if((t!==b)&&(t!=="")){t.mouseenter(function(){u=true});t.mouseleave(function(){u=false});var s=setTimeout(function(){if(u==true){t.mouseleave(function(){n.hideTooltip()})}else{n.hideTooltip()}},n.options.interactiveTolerance)}else{n.hideTooltip()}})}else{r.on("mouseleave.tooltipster",function(){n.hideTooltip()})}}if(this.options.trigger=="click"){r.on("click.tooltipster",function(){if((r.data("tooltipster")=="")||(r.data("tooltipster")==b)){n.showTooltip()}else{n.hideTooltip()}})}}}},showTooltip:function(m){var n=d(this.element);var l=this;if(n.data("tooltipsterIcon")!==b){n=n.data("tooltipsterIcon")}if(!n.hasClass("tooltipster-disable")){if((d(".tooltipster-base").not(".tooltipster-dying").length>0)&&(l.options.onlyOne==true)){d(".tooltipster-base").not(".tooltipster-dying").not(n.data("tooltipster")).each(function(){d(this).addClass("tooltipster-kill");var o=d(this).data("origin");o.data("plugin_tooltipster").hideTooltip()})}n.clearQueue().delay(l.options.delay).queue(function(){l.options.functionBefore(n,function(){if((n.data("tooltipster")!==b)&&(n.data("tooltipster")!=="")){var w=n.data("tooltipster");if(!w.hasClass("tooltipster-kill")){var s="tooltipster-"+l.options.animation;w.removeClass("tooltipster-dying");if(k==true){w.clearQueue().addClass(s+"-show")}if(l.options.timer>0){var q=w.data("tooltipsterTimer");clearTimeout(q);q=setTimeout(function(){w.data("tooltipsterTimer",b);l.hideTooltip()},l.options.timer);w.data("tooltipsterTimer",q)}if((l.options.touchDevices==true)&&(j())){d("body").bind("touchstart",function(B){if(l.options.interactive==true){var D=d(B.target);var C=true;D.parents().each(function(){if(d(this).hasClass("tooltipster-base")){C=false}});if(C==true){l.hideTooltip();d("body").unbind("touchstart")}}else{l.hideTooltip();d("body").unbind("touchstart")}})}}}else{d("body").css("overflow-x","hidden");var x=n.data("tooltipsterContent");var u=l.options.theme;var y=u.replace(".","");var s="tooltipster-"+l.options.animation;var r="-webkit-transition-duration: "+l.options.speed+"ms; -webkit-animation-duration: "+l.options.speed+"ms; -moz-transition-duration: "+l.options.speed+"ms; -moz-animation-duration: "+l.options.speed+"ms; -o-transition-duration: "+l.options.speed+"ms; -o-animation-duration: "+l.options.speed+"ms; -ms-transition-duration: "+l.options.speed+"ms; -ms-animation-duration: "+l.options.speed+"ms; transition-duration: "+l.options.speed+"ms; animation-duration: "+l.options.speed+"ms;";var o=l.options.fixedWidth>0?"width:"+l.options.fixedWidth+"px;":"";var z=l.options.maxWidth>0?"max-width:"+l.options.maxWidth+"px;":"";var t=l.options.interactive==true?"pointer-events: auto;":"";var w=d('<div class="tooltipster-base '+y+" "+s+'" style="'+o+" "+z+" "+t+" "+r+'"><div class="tooltipster-content">'+x+"</div></div>");w.appendTo("body");n.data("tooltipster",w);w.data("origin",n);l.positionTooltip();l.options.functionReady(n,w);if(k==true){w.addClass(s+"-show")}else{w.css("display","none").removeClass(s).fadeIn(l.options.speed)}var A=x;var p=setInterval(function(){var B=n.data("tooltipsterContent");if(d("body").find(n).length==0){w.addClass("tooltipster-dying");l.hideTooltip()}else{if((A!==B)&&(B!=="")){A=B;w.find(".tooltipster-content").html(B);if(l.options.updateAnimation==true){if(a()){w.css({width:"","-webkit-transition":"all "+l.options.speed+"ms, width 0ms, height 0ms, left 0ms, top 0ms","-moz-transition":"all "+l.options.speed+"ms, width 0ms, height 0ms, left 0ms, top 0ms","-o-transition":"all "+l.options.speed+"ms, width 0ms, height 0ms, left 0ms, top 0ms","-ms-transition":"all "+l.options.speed+"ms, width 0ms, height 0ms, left 0ms, top 0ms",transition:"all "+l.options.speed+"ms, width 0ms, height 0ms, left 0ms, top 0ms"}).addClass("tooltipster-content-changing");setTimeout(function(){w.removeClass("tooltipster-content-changing");setTimeout(function(){w.css({"-webkit-transition":l.options.speed+"ms","-moz-transition":l.options.speed+"ms","-o-transition":l.options.speed+"ms","-ms-transition":l.options.speed+"ms",transition:l.options.speed+"ms"})},l.options.speed)},l.options.speed)}else{w.fadeTo(l.options.speed,0.5,function(){w.fadeTo(l.options.speed,1)})}}l.positionTooltip()}}if((d("body").find(w).length==0)||(d("body").find(n).length==0)){clearInterval(p)}},200);if(l.options.timer>0){var q=setTimeout(function(){w.data("tooltipsterTimer",b);l.hideTooltip()},l.options.timer+l.options.speed);w.data("tooltipsterTimer",q)}if((l.options.touchDevices==true)&&(j())){d("body").bind("touchstart",function(B){if(l.options.interactive==true){var D=d(B.target);var C=true;D.parents().each(function(){if(d(this).hasClass("tooltipster-base")){C=false}});if(C==true){l.hideTooltip();d("body").unbind("touchstart")}}else{l.hideTooltip();d("body").unbind("touchstart")}})}w.mouseleave(function(){l.hideTooltip()})}});n.dequeue()})}},hideTooltip:function(m){var p=d(this.element);var l=this;if(p.data("tooltipsterIcon")!==b){p=p.data("tooltipsterIcon")}var o=p.data("tooltipster");if(o==b){o=d(".tooltipster-dying")}p.clearQueue();if((o!==b)&&(o!=="")){var q=o.data("tooltipsterTimer");if(q!==b){clearTimeout(q)}var n="tooltipster-"+l.options.animation;if(k==true){o.clearQueue().removeClass(n+"-show").addClass("tooltipster-dying").delay(l.options.speed).queue(function(){o.remove();p.data("tooltipster","");d("body").css("verflow-x","");l.options.functionAfter(p)})}else{o.clearQueue().addClass("tooltipster-dying").fadeOut(l.options.speed,function(){o.remove();p.data("tooltipster","");d("body").css("verflow-x","");l.options.functionAfter(p)})}}},positionTooltip:function(O){var A=d(this.element);var ab=this;if(A.data("tooltipsterIcon")!==b){A=A.data("tooltipsterIcon")}if((A.data("tooltipster")!==b)&&(A.data("tooltipster")!=="")){var ah=A.data("tooltipster");ah.css("width","");var ai=d(f).width();var B=A.outerWidth(false);var ag=A.outerHeight(false);var al=ah.outerWidth(false);var m=ah.innerWidth()+1;var M=ah.outerHeight(false);var aa=A.offset();var Z=aa.top;var u=aa.left;var y=b;if(A.is("area")){var T=A.attr("shape");var af=A.parent().attr("name");var P=d('img[usemap="#'+af+'"]');var n=P.offset().left;var L=P.offset().top;var W=A.attr("coords")!==b?A.attr("coords").split(","):b;if(T=="circle"){var N=parseInt(W[0]);var r=parseInt(W[1]);var D=parseInt(W[2]);ag=D*2;B=D*2;Z=L+r-D;u=n+N-D}else{if(T=="rect"){var N=parseInt(W[0]);var r=parseInt(W[1]);var q=parseInt(W[2]);var J=parseInt(W[3]);ag=J-r;B=q-N;Z=L+r;u=n+N}else{if(T=="poly"){var x=[];var ae=[];var H=0,G=0,ad=0,ac=0;var aj="even";for(i=0;i<W.length;i++){var F=parseInt(W[i]);if(aj=="even"){if(F>ad){ad=F;if(i==0){H=ad}}if(F<H){H=F}aj="odd"}else{if(F>ac){ac=F;if(i==1){G=ac}}if(F<G){G=F}aj="even"}}ag=ac-G;B=ad-H;Z=L+G;u=n+H}else{ag=P.outerHeight(false);B=P.outerWidth(false);Z=L;u=n}}}}if(ab.options.fixedWidth==0){ah.css({width:m+"px","padding-left":"0px","padding-right":"0px"})}var s=0,V=0;var X=parseInt(ab.options.offsetY);var Y=parseInt(ab.options.offsetX);var p="";function w(){var an=d(f).scrollLeft();if((s-an)<0){var am=s-an;s=an;ah.data("arrow-reposition",am)}if(((s+al)-an)>ai){var am=s-((ai+an)-al);s=(ai+an)-al;ah.data("arrow-reposition",am)}}function t(an,am){if(((Z-d(f).scrollTop()-M-X-12)<0)&&(am.indexOf("top")>-1)){ab.options.position=an;y=am}if(((Z+ag+M+12+X)>(d(f).scrollTop()+d(f).height()))&&(am.indexOf("bottom")>-1)){ab.options.position=an;y=am;V=(Z-M)-X-12}}if(ab.options.position=="top"){var Q=(u+al)-(u+B);s=(u+Y)-(Q/2);V=(Z-M)-X-12;w();t("bottom","top")}if(ab.options.position=="top-left"){s=u+Y;V=(Z-M)-X-12;w();t("bottom-left","top-left")}if(ab.options.position=="top-right"){s=(u+B+Y)-al;V=(Z-M)-X-12;w();t("bottom-right","top-right")}if(ab.options.position=="bottom"){var Q=(u+al)-(u+B);s=u-(Q/2)+Y;V=(Z+ag)+X+12;w();t("top","bottom")}if(ab.options.position=="bottom-left"){s=u+Y;V=(Z+ag)+X+12;w();t("top-left","bottom-left")}if(ab.options.position=="bottom-right"){s=(u+B+Y)-al;V=(Z+ag)+X+12;w();t("top-right","bottom-right")}if(ab.options.position=="left"){s=u-Y-al-12;myLeftMirror=u+Y+B+12;var K=(Z+M)-(Z+A.outerHeight(false));V=Z-(K/2)-X;if((s<0)&&((myLeftMirror+al)>ai)){var o=parseFloat(ah.css("border-width"))*2;var l=(al+s)-o;ah.css("width",l+"px");M=ah.outerHeight(false);s=u-Y-l-12-o;K=(Z+M)-(Z+A.outerHeight(false));V=Z-(K/2)-X}else{if(s<0){s=u+Y+B+12;ah.data("arrow-reposition","left")}}}if(ab.options.position=="right"){s=u+Y+B+12;myLeftMirror=u-Y-al-12;var K=(Z+M)-(Z+A.outerHeight(false));V=Z-(K/2)-X;if(((s+al)>ai)&&(myLeftMirror<0)){var o=parseFloat(ah.css("border-width"))*2;var l=(ai-s)-o;ah.css("width",l+"px");M=ah.outerHeight(false);K=(Z+M)-(Z+A.outerHeight(false));V=Z-(K/2)-X}else{if((s+al)>ai){s=u-Y-al-12;ah.data("arrow-reposition","right")}}}if(ab.options.arrow==true){var I="tooltipster-arrow-"+ab.options.position;if(ab.options.arrowColor.length<1){var R=ah.css("background-color")}else{var R=ab.options.arrowColor}var ak=ah.data("arrow-reposition");if(!ak){ak=""}else{if(ak=="left"){I="tooltipster-arrow-right";ak=""}else{if(ak=="right"){I="tooltipster-arrow-left";ak=""}else{ak="left:"+ak+"px;"}}}if((ab.options.position=="top")||(ab.options.position=="top-left")||(ab.options.position=="top-right")){var U=parseFloat(ah.css("border-bottom-width"));var z=ah.css("border-bottom-color")}else{if((ab.options.position=="bottom")||(ab.options.position=="bottom-left")||(ab.options.position=="bottom-right")){var U=parseFloat(ah.css("border-top-width"));var z=ah.css("border-top-color")}else{if(ab.options.position=="left"){var U=parseFloat(ah.css("border-right-width"));var z=ah.css("border-right-color")}else{if(ab.options.position=="right"){var U=parseFloat(ah.css("border-left-width"));var z=ah.css("border-left-color")}else{var U=parseFloat(ah.css("border-bottom-width"));var z=ah.css("border-bottom-color")}}}}if(U>1){U++}var E="";if(U!==0){var C="";var S="border-color: "+z+";";if(I.indexOf("bottom")!==-1){C="margin-top: -"+U+"px;"}else{if(I.indexOf("top")!==-1){C="margin-bottom: -"+U+"px;"}else{if(I.indexOf("left")!==-1){C="margin-right: -"+U+"px;"}else{if(I.indexOf("right")!==-1){C="margin-left: -"+U+"px;"}}}}E='<span class="tooltipster-arrow-border" style="'+C+" "+S+';"></span>'}ah.find(".tooltipster-arrow").remove();p='<div class="'+I+' tooltipster-arrow" style="'+ak+'">'+E+'<span style="border-color:'+R+';"></span></div>';ah.append(p)}ah.css({top:V+"px",left:s+"px"});if(y!==b){ab.options.position=y}}}};d.fn[e]=function(m){if(typeof m==="string"){var o=this;var l=arguments[1];if(o.data("plugin_tooltipster")==b){var n=o.find("*");o=d();n.each(function(){if(d(this).data("plugin_tooltipster")!==b){o.push(d(this))}})}o.each(function(){switch(m.toLowerCase()){case"show":d(this).data("plugin_tooltipster").showTooltip();break;case"hide":d(this).data("plugin_tooltipster").hideTooltip();break;case"disable":d(this).addClass("tooltipster-disable");break;case"enable":d(this).removeClass("tooltipster-disable");break;case"destroy":d(this).data("plugin_tooltipster").hideTooltip();d(this).data("plugin_tooltipster","").attr("title",o.data("tooltipsterContent")).data("tooltipsterContent","").data("plugin_tooltipster","").off("mouseenter.tooltipster mouseleave.tooltipster click.tooltipster");break;case"update":d(this).data("tooltipsterContent",l);break;case"reposition":d(this).data("plugin_tooltipster").positionTooltip();break}});return this}return this.each(function(){if(!d.data(this,"plugin_"+e)){d.data(this,"plugin_"+e,new h(this,m))}var p=d(this).data("plugin_tooltipster").options;if((p.iconDesktop==true)&&(!j())||((p.iconTouch==true)&&(j()))){var q=d(this).data("plugin_tooltipster");d(this).next().data("plugin_tooltipster",q)}})};if(j()){f.addEventListener("orientationchange",function(){if(d(".tooltipster-base").length>0){d(".tooltipster-base").each(function(){var l=d(this).data("origin");l.data("plugin_tooltipster").hideTooltip()})}},false)}d(f).on("resize.tooltipster",function(){var l=d(".tooltipster-base").data("origin");if((l!==null)&&(l!==b)){l.tooltipster("reposition")}})})(jQuery,window,document);
jQuery.fn.vibrate=function(e){var t=jQuery.extend({speed:30,duration:2e3,frequency:1e4,spread:3},e);return this.each(function(){var e=jQuery(this);var n=function(){var n=Math.floor(Math.random()*t.spread)-(t.spread-1)/2;var r=Math.floor(Math.random()*t.spread)-(t.spread-1)/2;var i=Math.floor(Math.random()*t.spread-(t.spread-1)/2);e.css({position:"relative",left:r+"px",top:n+"px",WebkitTransform:"rotate("+i+"deg)"})};var r=function(){var r=setInterval(n,t.speed);var i=function(){clearInterval(r);e.css({position:"static"})};setTimeout(i,t.duration)};r()})}
jQuery.fn.center=function(){this.css("position","fixed");this.css("top",Math.max(0,(($(window).height()-$(this).outerHeight())/2))+"px");this.css("left",Math.max(0,(($(window).width()-$(this).outerWidth())/2)+$(window).scrollLeft())+"px");return this}

function isEmail(email) {
  var regex = /^([a-zA-Z0-9_\.\-\+])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
  return regex.test(email);
}

(function($){
    $.fn.extend({

    //pass the options variable to the function
    hiwaccord: function(options) {
        
		var defaults = {
			hiwaccord: 'true',
			speed: 300,
			closedSign: '[+]',
			openedSign: '[-]'
		};

		// Extend our default options with those provided.
		var opts = $.extend(defaults, options);
		//Assign current element to variable, in this case is UL element
 		var $this = $(this);
 		
 		//add a mark [+] to a multilevel menu
 		$this.find("li").each(function() {
 			if($(this).find("ul").size() != 0){
 				//add the multilevel sign next to the link
 				$(this).find("a:first").append("<span>"+ opts.closedSign +"</span>");
 				
 				//avoid jumping to the top of the page when the href is an #
 				if($(this).find("a:first").attr('href') == "#"){
 		  			$(this).find("a:first").click(function(){return false;});
 		  		}
 			}
 		});

 		//open active level
 		$this.find("li.active").each(function() {
 			$(this).parents("ul").slideDown(opts.speed);
 			$(this).parents("ul").parent("li").find("span:first").html(opts.openedSign);
 		});

  		$this.find("li a").click(function() {
  			if($(this).parent().find("ul").size() != 0){
  				if(opts.hiwaccord){
  					//Do nothing when the list is open
  					if(!$(this).parent().find("ul").is(':visible')){
  						parents = $(this).parent().parents("ul");
  						visible = $this.find("ul:visible");
  						visible.each(function(visibleIndex){
  							var close = true;
  							parents.each(function(parentIndex){
  								if(parents[parentIndex] == visible[visibleIndex]){
  									close = false;
  									return false;
  								}
  							});
  							if(close){
  								if($(this).parent().find("ul") != visible[visibleIndex]){
  									$(visible[visibleIndex]).slideUp(opts.speed, function(){
  										$(this).parent("li").removeClass('active-menu').find("span:first").html(opts.closedSign);
  									});
  									
  								}
  							}
  						});
  					}
  				}
  				if($(this).parent().find("ul:first").is(":visible")){
  					$(this).parent().find("ul:first").slideUp(opts.speed, function(){
  						$(this).parent("li").removeClass('active-menu').find("span:first").delay(opts.speed).html(opts.closedSign);
  					});
  					
  					
  				}else{
					$(this).parent().find("ul:first").parent("li").addClass('active-menu');
  					$(this).parent().find("ul:first").slideDown(opts.speed, function(){
  						$(this).parent("li").find("span:first").delay(opts.speed).html(opts.openedSign);
  					});
  				}
  			}
  		});
    }
});
})(jQuery);