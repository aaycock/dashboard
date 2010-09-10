$(document).ready(function() {
  
	var $gridSections = $("#griddler_ii article");
	
	$gridSections.hover
	(
		function()
		{
			$gridSections.removeClass("selected");
		}
	);
	$("#griddler_ii").height($gridSections.filter(':first').outerHeight(true))
});