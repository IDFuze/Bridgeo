function loadExtJs(filename, callback) {
  var f=document.createElement("script");
  f.setAttribute("type","text/javascript");
  f.setAttribute("src", filename);
  if (f.readyState){  //IE
    f.onreadystatechange = function(){
      if (f.readyState == "loaded" || f.readyState == "complete"){
        f.onreadystatechange = null;
        callback();
      }
    };
  } else {  //Others
    f.onload = function() { callback(); };
  }
 document.getElementsByTagName("head")[0].appendChild(f)
}

var checkLibs = function() {
  // Load jQuery and underscore.js & mustache.js
  loadExtJs("/assets/jquery.js", function() {
    loadExtJs("/assets/underscore.js", function() {
      loadExtJs("/assets/mustache.js", function() {
        loadExtJs("/assets/bootstrap-modal.js", function() {
          $("head").append('<link rel="stylesheet" href="/assets/bridgeo.css">');
          $("head").append('<link rel="stylesheet" href="/assets/bs.css">');
          $.get("/home/loadlayout");  
          loadUI();
        });
      });
    });
  });    
}

var current_widget = null;

var loadUI = function() {
  // Load Modal dialog
  $("body").append('<div id="b-modal" class="modal hide fade" style="display: none; "><div class="modal-header"></div><div class="modal-body">Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</div><div class="modal-footer"></div></div>');
  // Create contextmenudiv
  $("body").append('<div id="b-contextmenu" class="b-menu"></div>');
  
  $(".b-widget").live("mouseover", function() {
    $(this).addClass("bridgeo-hover");
    $(".b-widget-edit").remove(); 
  });
  $(".b-widget").live("mouseout", function() {
    $(this).removeClass("bridgeo-hover");
  });
  $(".b-widget").live("click", function() {
    current_widget = $(this);
    if($(this).attr("data-type") == "html") {
      $(".b-editor").remove();
      $(this).before("<div class='b-editor well'><a href='#' class='btn b-e-b'>G</a><a href='#' class='btn b-e-i'>I</a><a href='#' class='btn b-e-s'>S</a> <a href='#' class='btn a0 success'>Sauvegarder</a> <a href='#' class='btn a1 danger'>X</a></div>");
      $(this).attr("contenteditable", "true");
    }      
  });
  // Disable all contextmenu
  $(document).bind("contextmenu",function(e){
    return false;
  });
  $(document).bind("click",function(e){
    $("#b-contextmenu").fadeOut();
  });
  
  $('.b-widget').live("mousedown", function(event) {
    if(event.which == 3) {
      $.get("/home/getcontextmenu/"+$(this).attr("id")+"?page="+page, function(data) { 
        $("#b-contextmenu").html(data).css("top", event.pageY - 10).css("left", event.pageX + 10); 
        $("#b-contextmenu").show();
      });
    }
  });
  // Editor
  $("a.a1").live("click", function() {
    $(".b-editor").remove();
    current_widget.attr("contenteditable", "false");
  });
  $("a.a0").live("click", function() {
    alert("Saved!");
  });
  $("a.b-e-b").live("click", function() { document.execCommand("bold",false,null); });
  $("a.b-e-i").live("click", function() { document.execCommand("italic",false,null); });
  $("a.b-e-s").live("click", function() { document.execCommand("underline",false,null); });
}
window.onload = checkLibs();