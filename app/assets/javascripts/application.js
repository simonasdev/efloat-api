// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require lodash
//= require activestorage
//= require turbolinks
//= require bootstrap
//= require moment
//= require moment/lt
//= require bootstrap-datetimepicker
//= require leaflet
//= require iso8601-js-period
//= require leaflet-timedimension
//= require_tree .

$(document).on('turbolinks:load', function () {
  setActiveModule();
  initializeMap();
  initializeRouteMaps();
  initializeTimelineMap();
  initializeConnectedDevices();

  $('.datetimepicker').datetimepicker();
});

function copyToClipboard(value) {
  var textArea = document.createElement("textarea");
  textArea.style.opacity = 0;
  textArea.style.position = 'fixed';
  textArea.value = value;

  document.body.appendChild(textArea);
  textArea.focus();
  textArea.select();

  document.execCommand('copy');

  document.body.removeChild(textArea);
}

function setActiveModule () {
  var path = window.location.pathname;

  _.find($('#navbar ul > li').toArray(), function (element) {
    var $element = $(element);
    var $link = $element.find('a');
    var patterns = _.compact(_.flatten([$link.attr('href'), $link.data('urls')]));

    return patterns.some(function (pattern) {
      return pattern === '/' ? pattern === path : _.startsWith(path, pattern);
    }) ? $element.addClass('active') : false;
  });
}

function toggleFeedback (id, reset) {
  reset = reset || false;

  $('.toggle-feedback').each(function (i, el) {
    var feedbackItems = $(el).find('.input-group-addon').children();

    feedbackItems.addClass('hidden');
    feedbackItems.filter('#' + id).removeClass('hidden');
  })
}
