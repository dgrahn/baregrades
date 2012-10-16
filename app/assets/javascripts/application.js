//= require jquery
//= require jquery_ujs
//= require_tree .


$(document).ready(function() {
	/* -- Grade scale expand button -- */
	var minorGrades = $(".scale .plus, .scale .minus");
	var gradeButton = $(".scale .button");
	minorGrades.hide();

	gradeButton.click(function() {
		if(minorGrades.is(":visible")) {
			minorGrades.slideUp();
			$(this).html('+');
		} else {
			minorGrades.slideDown();
			$(this).html('-');
		}
	});
});