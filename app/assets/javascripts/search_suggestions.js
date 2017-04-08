$(document).on('turbolinks:load', function(){
  $('#search').autocomplete({
    source: '/search_suggestions'
  });
});
