/**
 *	UI Layout Callback: resizePaneAccordions
 *
 *	This callback is used when a layout-pane contains 1 or more accordions
 *	- whether the accordion a child of the pane or is nested within other elements
 *	Assign this callback to the pane.onresize event:
 *
 *	SAMPLE:
 *	$("#elem").tabs({ show: $.layout.callbacks.resizePaneAccordions });
 *	$("body").layout({ center__onresize: $.layout.callbacks.resizePaneAccordions });
 *
 *	Version:	1.0 - 2011-07-10
 *	Author:		Kevin Dalman (kevin.dalman@gmail.com)
 */
;(function ($) {
var _ = $.layout;

// make sure the callbacks branch exists
if (!_.callbacks) _.callbacks = {};

_.callbacks.resizePaneAccordions = function (x, ui) {
	// may be called EITHER from layout-pane.onresize OR tabs.show
	var $P = ui.jquery ? ui : $(ui.panel);
	// find all VISIBLE accordions inside this pane and resize them
	$P.find(".ui-accordion:visible").each(function(){
		var $E = $(this);
		if ($E.data("accordion"))
			$E.accordion("resize");
	});
};
})( jQuery );
