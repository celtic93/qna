$(document).on('turbolinks:load', function(){
  $('.rating').on('ajax:success', function(e) {
    console.log(e.detail[0]);
    var votable = e.detail[0];
    var votable_id = '#' + votable["votable_type"] + '-' + votable["votable_id"];
    $($(votable_id).find('.rating-count')).html("Rating: " + votable["rating"]);

    if ($(votable_id).find('.vote-links').hasClass('hidden')) {
      $(votable_id).find('.vote-links').show();
      $(votable_id).find('.revote-link').hide();
    } else {
      $(votable_id).find('.vote-links').hide();
      $(votable_id).find('.revote-link').show();
    };
  })
});
