function initializeTimelineMap() {
  var $map = $('#timeline-map');

  if ($map.length) {
    var map = L.map(
      $map.attr('id'),
      _.assign({}, defaultMapOptions(), {

      })
    );

    addTracksToMap($map.data('tracks'), map);
  }
}

function initializeConnectedDevices () {
  var interval;

  if ($('#connected-devices').length) {
    interval = window.setInterval(function () {
      $.get('/devices/connected', function (response) {
        $('#connected-devices').html(response);
      });
    }, 2000);
  } else if (interval) {
    window.clearInterval(interval);
    interval = null;
  }
}
